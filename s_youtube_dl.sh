#!/bin/bash
PLAYLIST_URL=$1
LOGFILE="./youtube-dl.log"
rm $LOGFILE
CMD="/usr/local/bin/youtube-dl --cookies ./cookies.log --extract-audio --audio-format mp3 --ignore-errors $PLAYLIST_URL 2>&1 | tee $LOGFILE"
echo $CMD && eval $CMD
echo "Number of titles "$(cat $LOGFILE | grep "Downloading video" | wc -l)
echo "Error found "$(cat $LOGFILE | grep "ERROR")
cat $LOGFILE | grep "Downloading video" | wc -l
