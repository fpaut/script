#!/bin/bash
#timestamp
yy=$(eval "date +%Y")
mm=$(eval "date +%m")
dd=$(eval "date +%d")
hh=$(eval "date +%H")
mn=$(eval "date +%M")
ss=$(eval "date +%S")
filename="capture_$yy-$mm-$dd-$hh:$mn:$ss.png"
echo $filename
CMD="import -pause 3 /home/$USER/Images/$filename"
echo $CMD
eval "$CMD"
xdg-open "/home/$USER/Images/$filename"&
path_dest=$(eval "zenity --file-selection --save --filename=$filename")
mv /home/$USER/Images/$filename $path_dest
xdg-open "$path_dest"