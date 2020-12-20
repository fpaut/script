#!/bin/bash
# Used to execute un custom command with some apps
FILE="$1"
terminator -e \"echo $FILE\"
read
