SCRIPT_NAME=$(basename "$0")
IMG_PATTERN=$1
OUTPUT="$2"
source ~/bin/scripts/.bash_tools.sh
source ~/bin/scripts/.bashrc_aliases.sh
my_ls()
{
    ext=$1
    for f in {000..105}.$ext
    do
        if [[ -e $f ]]; then
            echo $f
        fi
    done
}


# be sure each filename have at least 8 digits
log_debug $CYAN"$SCRIPT_NAME: be sure each filename have at least 2 digits"$ATTR_RESET
ls $IMG_PATTERN | while read file
do
    filename=$(file_get_name $file)
    ext=$(file_get_ext $file)
	filename=$(pad_number $filename 8)
	if [[ -e "$file" ]]; then
        CMD="mv -f $file $filename.$ext"; echo $CMD; $CMD
        exit_on_error
    fi
done

# Convert each image as a pdf
log_debug $CYAN"$SCRIPT_NAME: Convert each image as a pdf"$ATTR_RESET
ls $IMG_PATTERN | while read file
do
    filename=$(file_get_name $file)
    CMD="convert $file $filename.pdf"; echo $CMD; $CMD; ERR=$?
	if [[ "$ERR" != "0" ]]; then
		echo convert return $ERR > /dev/stderr
	fi
done

# Concatenate all pdf as one
log_debug $CYAN"$SCRIPT_NAME: Concatenate all pdf as one"$ATTR_RESET
FILE_LIST=$(ls *.pdf)
CMD="pdftk $FILE_LIST cat output $OUTPUT"
#CMD="java -jar /mnt/c/Users/fpaut/dev/Perso/pdftk/build/jar/pdftk.jar $FILE_LIST cat output $OUTPUT"
echo $CMD
eval $CMD; ERR="$?"

log_debug $CYAN"Return from $SCRIPT_NAME with status $?"$ATTR_RESET


