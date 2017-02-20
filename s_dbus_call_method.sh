#! /bin/bash
BUS=$1
SERVICE=$2
OBJPATH=$3
INTERFACE=$4
METHOD=$5
PARAMETERS=$6
echo $0 " with :"
echo "BUS=#1="$BUS
echo "SERVICE=#2="$SERVICE
echo "OBJPATH=#3="$OBJPATH
echo "INTERFACE=#4="$INTERFACE
echo "METHOD=#5="$METHOD
echo "PARAMETERS=#6="$PARAMETERS
echo 'SAMPLE: '$0 ' session org.gnome.UPnP.MediaServer2.cloudeebus /org/gnome/UPnP/MediaServer2/Music org.gnome.UPnP.MediaContainer2 ListChildren "uint32:0 uint32:0 array:string:''*''"'
CMD='dbus-send --print-reply --'$BUS' --dest='$SERVICE' '$OBJPATH' '$INTERFACE'.'$METHOD' '$PARAMETERS
echo $CMD
$CMD