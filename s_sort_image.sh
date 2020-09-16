#!/bin/bash
if [[ "${#}" < 2 ]]; then
    echo "#1 parameter define the action 'move'/'copy'/'link'"
    echo "#2 parameter define the source folder"
    echo "#3 parameter (optional) define the destination folder. Current folder if omitted"
    exit 1
fi
action=$1
source=$2
dest=$3
if [[ -z $dest ]]; then
    dest=$(pwd)
fi
echo action=$action
echo source=$source
echo dest=$dest
