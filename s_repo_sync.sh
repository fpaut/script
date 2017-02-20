#!/bin/bash
set -u
TIME_TOOL=$(which time)
SYNC_CMD="$REPO sync $@"
OUT_FILE="./repo_sync.txt"

printf "$SYNC_CMD\n"
printf "$SYNC_CMD\n" > $OUT_FILE
printf "SYNC START TIME=$(date +%c)\n"
eval $SYNC_CMD
printf "SYNC END TIME=$(date +%c)\n"
