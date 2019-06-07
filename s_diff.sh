#!/bin/bash
folder1="$1"
folder2="$2"

folder_diff="$folder1//diff"
folder_equ="$folder1//identical"
folder_not="$folder1//not_present"
mkdir -pv $folder_equ
mkdir -pv $folder_diff
mkdir -pv $folder_not

get_path() {
    file=$1
}


ls $folder1 | while read file
do
    if [ -f "$folder1//$file" ]; then
        if [ -e "$folder2//$file" ]; then
            CMD="diff -rqs \"$folder1//$file\" \"$folder2//$file\""; echo $CMD; eval $CMD
            if [ "$?" -eq "0" ]; then
                CMD="mv -v \"$folder1//$file\" \"$folder_equ//$file\""; eval $CMD
                
            else
                CMD="mv -v \"$folder1//$file\" \"$folder_diff//$file\""; eval $CMD
            fi
        else
            echo "$folder2//$file doesn't exist!"
            CMD="mv -v \"$folder1//$file\" \"$folder_not//$file\""; eval $CMD
        fi
        echo "------------------------------------------------------------------"
    fi
done
