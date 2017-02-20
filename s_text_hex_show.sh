#!/bin/bash
string=$@
echo "Value in ASCII : $string"
echo -n "Value in HEX :"
echo -en $string | od -A n -t x1
echo "Using 'hexdump' :"
echo -en "$string" | hexdump -C
