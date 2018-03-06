#!/bin/bash
url=$1

if [ -z $threads ]; then
    echo "#1 is the url"
fi


uget-gtk $url
