#!/bin/bash
PLAYLIST_URL=$1
CMD="youtube-dl --extract-audio --audio-format mp3 $PLAYLIST_URL"
echo $CMD && eval $CMD

