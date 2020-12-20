#!/bin/bash
VIEWER="/bin/xnview"
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
if [[ "$?" == "0" ]]; then
    echo Moving...
    mv /home/$USER/Images/$filename $path_dest
    $VIEWER "$path_dest"
else
    echo Deleting...
    rm /home/$USER/Images/$filename
fi
