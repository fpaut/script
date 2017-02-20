#!/bin/bash
threads=$1
url=$2

if [ -z $threads ]; then
    echo "#1 is the number of threads"
    echo "#2 is the url"
    exit 1
fi

axel --alternate --verbose --num-connections=$threads $url
