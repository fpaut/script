#!/system/bin/sh
pattern=$1
CMD="su -c find /data/data -iname \"*$pattern*\" | grep -v \"POUBELLE\""
echo $CMD
FOLDER=$(eval $CMD)
FOLDER_FULLNAME=$(eval dirname \"$FOLDER\")
FOLDER=${FOLDER_FULLNAME##*/data/data/}
FOLDER=${FOLDER%%/*}

if [[ "$FOLDER" != "" && "$FOLDER" != "." ]]; then
    REPLY=""
    FOLDER_TO_MV="/data/data/$FOLDER"
    read -e -i "Y" -p "Move '$FOLDER_TO_MV' in '/data/data/POUBELLE/$FOLDER' ( (Y)es / (n)o? : "
    if [ "$REPLY" == "y" ] || [ "$REPLY" == "Y" ]; then
        CMD="su -c mkdir /data/data/POUBELLE"
        echo $CMD; $CMD
        CMD="su -c mv  $FOLDER_TO_MV /data/data/POUBELLE/$FOLDER"
        echo "FOLDER /data/data/$FOLDER renamed /data/data/POUBELLE/$FOLDER"
        echo $CMD; FOLDER=$(eval $CMD)
    fi    
else
    echo "No folder found!"
fi
echo
read -e -i "N" -p "Searching residual 'POUBELLE' folders ( (y)es / (N)o? : "
if [ "$REPLY" == "y" ] || [ "$REPLY" == "Y" ]; then
    CMD="su -c find /data/data -iname *POUBELLE*"
    echo $CMD; $CMD
    CMD="su -c ls -l /data/data/POUBELLE"
    echo $CMD; $CMD
fi
