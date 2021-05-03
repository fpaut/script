#!/bin/bash
PATH_BACKUP_HD2To="/media/user/NTFS_1To82/WikoUFEEL/Memoire_Interne/BACKUP_Wiko_Fred"

alias ll="ls -halF --color=never"
alias cdbackup="cd $PATH_BACKUP_HD2To"

get_mtp() {
    userID=$(id $USER)
    userID=${userID#*uid=}
    userID=${userID%%($USER)*}
    MTP=$(ls /run/user/$userID/gvfs/)
    echo "/run/user/$userID/gvfs/"$MTP 
}

get_backup_path()
{
    echo $PATH_BACKUP_HD2To
}

ls_backup()
{
    ll  $PATH_BACKUP_HD2To/data/$1
}

push_backup()
{
    path=$1
    CMD="cp -vR \"$PATH_BACKUP_HD2To/data/$path\"  \"$(get_mtp)/Carte SD SanDisk//Download/backup/\""; echo $CMD; eval $CMD
    CMD="adb shell su -c cp -vR \"/data/data/$path /data/data/$path.OLD\""; echo $CMD;  eval "$CMD"
    CMD="adb shell su -c cp -vR /storage/sdcard1//Download/backup/$(basename $path) /data/data/$path"; echo $CMD;  eval "$CMD"
}
