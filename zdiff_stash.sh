#!/bin/bash
REV=$1
STASHS=""
STASHS=$(git stash list | while read stash | grep "diff --git" | while read file; do file=${file##*b/}; echo "$file"; done)
itemNb=$(tr -dc '\n' <<<"$STASHS" | wc -l)
echo itemNb=$itemNb
STASHS_TO_CMP=$(zenity --list --multiple --separator=" " --height=500 --column=STASHS $STASHS)
##STASHS_TO_CMP=${STASHS_TO_CMP//|/ }
for file in $STASHS_TO_CMP
do 
	CMD="git difftool -y $REV -- $file"
	echo $CMD
	$CMD
done