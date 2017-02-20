#!/bin/bash
CMD="sudo fsck -v $@"
echo "$CMD"
eval $CMD
