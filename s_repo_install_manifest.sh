#!/bin/bash
set -u
CMD="cp $1 .repo/manifests/"; echo $CMD; eval $CMD
CMD="$REPO init -m $1"; echo $CMD; eval $CMD
CMD="$REPO sync -d"; echo $CMD; eval $CMD
