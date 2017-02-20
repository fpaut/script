#!/bin/bash
set -u
CMD="$REPO manifest -o $1 -r"
echo $CMD
eval $CMD
