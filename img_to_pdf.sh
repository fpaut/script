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
    ext=$(file_get_ext $file)
	filename=$(pad_number $filename 4)
    CMD="mv $file $filename.$ext"; echo $CMD; $CMD
done

# Convert each image as a pdf
ls $IMG_PATTERN | while read file
do
    filename=$(file_get_name $file)
    CMD="convert $file $filename.pdf"; echo $CMD; $CMD
done

# Concatenate all pdf as one
FILE_LIST=$(ls *.pdf)
CMD="pdftk $FILE_LIST cat output $OUTPUT"
CMD="java -jar /mnt/c/Users/fpaut/dev/Perso/pdftk/build/jar/pdftk.jar $FILE_LIST cat output $OUTPUT"
echo $CMD
eval $CMD

#CMD="rm -f $(my_ls jpg*)"
#echo $CMD; $CMD
#CMD="rm -f $(my_ls png*)"
#echo $CMD; $CMD

