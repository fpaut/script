#!/bin/bash
CMD="sudo mke2fs -n $@"
echo "$CMD"
eval $CMD
