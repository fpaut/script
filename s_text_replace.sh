#!/bin/bash
substring=$1; shift
replacement=$1; shift
string=$@
output=${string//"$substring"/"$replacement"}
echo "output=$output"
