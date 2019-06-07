#!/usr/bin/env bash
scriptname=$0
scriptname=$(basename "$scriptname")
scriptname=${scriptname%.*}
filename_full=./$scriptname"-full.txt"
filename_cks=./$scriptname"-same-cks.txt"
filename_name=./$scriptname"-same-name.txt"

source ~/bin/scripts/s_bash_tools.sh
shopt -s lastpipe ## prevent bash to not creating a subshell (pipes spawn separate subprocesses)
def_font_attributes
index=0
folder_list="$@"
folder2="$2"


Calculate_cks()
{
    folder=$1
    ls $folder | while read file
    do
        if [ -f "$folder//$file" ]; then
            percent=$(( $((count * 100)) / $file_number))
            echo -n "$percent%: "
            c_exec "cksum \"$folder//$file\""; cksum=$OUT
            cksum=${cksum%% *}
            cks_array[$index]=$cksum
            file_array[$index]="$folder/$file"
            echo -e "${cks_array[$index]}\t${file_array[$index]}" >> $filename_full
            index=$((index+1))
            count=$((count+1))
       fi
    done
}

rm -rf $filename_full $filename_cks $filename_name
# Calculate number of files
file_number=0
for folder in $folder_list
do
    file_number=$(( $file_number + $(find $folder -type f | wc -l) ))
done
echo -e $GREEN"Found $file_number files" $ATTR_RESET

# Calculate all checksums files and store then in array
count=1
for folder in $folder_list
do
    folder=$(dirname $folder)/$(basename $folder) # Remove final '/'
     Calculate_cks $folder
done

# Save array
file_array_svg=${file_array[*]}
cks_array_svg=${cks_array[*]}


# Searching common checksums
array_lenght=$index
for ((i=0; i<${array_lenght}; i++ ))
do 
    if [[ ${cks_array[i]} != 0 ]]; then # Checksum set to '0' when already processed
        cks_cmp=${cks_array[i]}
        for ((j=0; j<${array_lenght}; j++ ))
        do 
            if [[ ${file_array[i]} != ${file_array[j]} ]]; then
                if [[ "$cks_cmp" ==  "${cks_array[j]}" ]]; then
                    echo -e $RED ${file_array[i]} has same checksum than ${file_array[j]} $ATTR_RESET
                    echo -e "${cks_array[$i]}\t${file_array[$i]}\t${file_array[$j]}" >> $filename_cks
                   ## Avoid recompare same checksum
                    cks_array[j]=$(( $(( $((i + 1)) * 10)) + $((j+1)) ))
 ##                   echo "cks_array[j]="${cks_array[j]}
                fi
            else
                    echo -e $BLUE File ignored. Same files. ${file_array[i]} / ${file_array[j]} $ATTR_RESET >> $filename_cks             
            fi
        done
        cks_array[i]=$(( $((i + 1)) * 10))
 ##       echo "cks_array[i]="${cks_array[i]}
    fi
done


# Searching common filename
for ((i=1; i<${array_lenght}; i++ ))
do 
    file1=$(basename "${file_array[i]}")
    if [[ ${file_array[i]} != "" ]]; then # Checksum set to '0' when already processed
        for ((j=0; j<${array_lenght}; j++ ))
        do 
            file2=$(basename "${file_array[j]}")
            if [[ "${file_array[i]}" != "${file_array[j]}" ]]; then
                if [[ "$file1" == "$file2" ]]; then
                    echo -e $RED ${file_array[i]} has same name than ${file_array[j]} $ATTR_RESET
                    echo -e "${file_array[$i]}\t==\t${file_array[$j]}" >> $filename_name
                    ## Avoid recompare same checksum
                    file_array[j]=""
    ##                   echo "cks_array[j]="${cks_array[j]}
                fi
            else
                echo -e "${file_array[$i]}\t<>\t${file_array[$j]}" >> $filename_name
            fi
        done
        file_array[i]=""
 ##       echo "cks_array[i]="${cks_array[i]}
    fi
done

echo -e $GREEN"Files generated : "$ATTR_RESET
echo -e $GREEN"Full list of files processed : $filename_full"$ATTR_RESET
echo -e $GREEN"Files with common checksum: $filename_cks"$ATTR_RESET
echo -e $GREEN"Files with same filename: $filename_name"$ATTR_RESET

