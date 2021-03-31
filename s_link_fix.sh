#!/bin/bash
if [[ "$#" < "2" ]]; then
    echo "#1 is the source path of the folder where the links are"
    echo "#2 is the base path where the linked files must be searched"
    exit 1
fi
SOURCE_PATH="$1"
SEARCH_PATH="$2"
POUBELLE="$SOURCE_PATH/POUBELLE"

check_var()
{
    var="$1"
    value=${!var}
    [ -z "${value}"  ] && echo $var is empty && exit 1
}

check_img()
{
    local img_file="$1"
    check_var POUBELLE
    TEST=$(file "$img_file" | grep " image")
    if [[ "$TEST" == "" ]]; then
        echo but corrupt
        if [ -e "$img_file" ]; then
            mv -v "$img_file" "$POUBELLE"
        else
            echo "'locate' not updated"
        fi
    else
        echo and correct
    fi
}

my_locate()
{
    local file="$1"
    check_var EXCLUDE_PATTERN
    locate $file | grep -v $EXCLUDE_PATTERN | while read src_file
    do
        echo -n "Found $src_file "
        check_img "$src_file"
    done
}

EXCLUDE_PATTERN=$SOURCE_PATH
if [[ "$SOURCE_PATH" == "." ]]; then
    EXCLUDE_PATTERN=$(pwd)
fi
EXCLUDE_PATTERN=${EXCLUDE_PATTERN##*/}
mkdir -p $POUBELLE
check_var SOURCE_PATH
ls "$SOURCE_PATH" | while read file
do
    if [[ -L "$file" ]]; then
        if [ ! -e "$file" ] ; then
            echo "$file is a broken link (original target was $(readlink -m $file)"
            my_locate $file
            echo
        fi
    fi
done
    
