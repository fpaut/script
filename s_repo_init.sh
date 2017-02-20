#!/bin/bash
if [ $# -lt 2 ]; then
	echo "2 parameters needed. 'project name' + 'repo parameters'"
	exit 1
fi
set -u
TIME_TOOL=$(which time)
prj=$1
url=$2
INIT_CMD="$REPO init $url"
OUT_FILE="repo_init.txt"
PRJ_OUT_FILE="repo_init-$prj.txt"
DATE_START=$(date +%F_%Hh:%Mmn)

if [ -e "$OUT_FILE" ]; then
	mv "$OUT_FILE" "$OUT_FILE"_$DATE_START
fi

printf "$INIT_CMD\n"
printf "$INIT_CMD\n" > $PRJ_OUT_FILE
ln -s $PRJ_OUT_FILE $OUT_FILE
printf "INIT START TIME=$(date +%c)\n"
eval $INIT_CMD
printf "INIT END TIME=$(date +%c)\n"

