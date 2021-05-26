SCRIPT_NAME=$(basename "$0")
source ~/bin/scripts/.bash_tools.sh
source ~/bin/scripts/.bashrc_aliases.sh

cleaning_all_pdf()
{
    src_folder="$1"
    rm -rf "$src_folder"/*.pdf 2>&1 1>/dev/null
}
export cleaning_all_pdf


# be sure each filename have at least 8 digits
normalize_filename()
{
    src_folder="$1"
    nb_digits="$2"
    img_pattern="$3"
    
    log_debug "normalize_filename($src_folder)"
    log_debug "$SCRIPT_NAME: be sure each filename have at least "$nb_digits" digits"
    ls "$src_folder" | egrep --color=never  "$img_pattern"
    ls "$src_folder" | egrep --color=never  "$img_pattern" | while read file
    do
        filename=$(file_get_name $file)
        ext=$(file_get_ext $file)
        # pad filename with '0' on the left (for alphabetical sorting with number as filename)
        newname=$(str_pad_left "$filename" "$nb_digits" "0").$ext
        log_debug Normalize $file to $newname
        if [[ -e "$src_folder/$file" && ! -e $src_folder/$newname ]]; then
            CMD="mv -f $src_folder/$file $src_folder/$newname"; log_debug $CMD; $CMD
            exit_on_error
        else
            log_debug "normalize_filename():$src_folder/$newname already exist!"
        fi
    done
}
export normalize_filename

# Convert each image as a pdf
convert_img_as_pdf()
{
    src_folder="$1"
    img_pattern="$2"
    
    log_debug $CYAN"$SCRIPT_NAME: Convert each image as a pdf"$ATTR_RESET
    ls $src_folder | egrep --color=never "$img_pattern" | while read file
    do
        filename=$(file_get_name $file)
        if [[ ! -e $src_folder/$filename.pdf ]]; then
            CMD="convert $src_folder/$file $src_folder/$filename.pdf"; log_debug $CMD; eval "$CMD"; ERR=$?
            if [[ "$ERR" != "0" ]]; then
                logfile_err convert return $ERR > /dev/stderr
            fi
        else
            log_debug $src_folder/$filename.pdf already exists!
        fi
    done
}
export convert_img_as_pdf

# Concatenate all pdf as one
# Convert each image as a pdf
create_final_pdf()
{
    src_folder="$1"
    dest_name="$2"    
    log_debug $CYAN"$SCRIPT_NAME: Concatenate all pdf as one"$ATTR_RESET
    FILE_LIST=$(ls $src_folder/*.pdf)
    CMD="pdftk $FILE_LIST cat output $dest_name"
    log_debug $CMD
    eval $CMD; ERR="$?"
}
export create_final_pdf


