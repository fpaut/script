#!/bin/bash
REV=$1
FILES=""
##FILES=$(git diff $REV | grep "diff --git" | while read file; do echo "(${file##*b/} )"; done)
FILES=$(git diff $REV | grep "diff --git" | while read file; do file=${file##*b/}; echo "$file"; done)
itemNb=$(tr -dc '\n' <<<"$FILES" | wc -l)
echo itemNb=$itemNb
FILES_TO_CMP=$(zenity --list --multiple --separator=" " --height=500 --column=FILES $FILES)
##FILES_TO_CMP=${FILES_TO_CMP//|/ }
for file in $FILES_TO_CMP
do 
	CMD="git difftool -y $REV -- $file"
	echo $CMD
	$CMD
done