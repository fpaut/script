#!/bin/bash
CMD="sudo lsof /var/lib/apt/lists/lock 2>/dev/null"
echo $CMD
eval $CMD
