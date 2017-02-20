#!/bin/bash

if ping -c 1 -W 2 google.com > /dev/null; then
 echo "Up"
else
 echo "Down"
fi
