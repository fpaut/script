IMG_PATTERN=$1
OUTPUT="$2"
source ~/bin/scripts/.bash_tools.sh
rm *.pdf 2>/dev/null
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


# be sure each filename have at least 2 digits
ls $IMG_PATTERN | while read file
do
    filename=$(file_get_name $file)
    if [[ $(var_get_length "$filename") < 2 ]]; then
        CMD="mv $file $(printf %02d 3)$file"; echo $CMD; $CMD
    fi
    if [[ $(var_get_length "$filename") < 3 ]]; then
        CMD="mv $file $(printf %d 3)$file"; echo $CMD; $CMD
    fi
done

# Convert each image as a pdf
ls $IMG_PATTERN | while read file
do
    filename=$(file_get_name $file)
    CMD="convert $file $filename.pdf"; echo $CMD; $CMD
done

# Concatenate all pdf as one
CMD="pdftk $(my_ls pdf) cat output $OUTPUT"
echo $CMD
eval $CMD

CMD="rm -f $(my_ls jpg*)"
echo $CMD; $CMD
CMD="rm -f $(my_ls png*)"
echo $CMD; $CMD

