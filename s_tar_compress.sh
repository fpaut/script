#!/bin/bash
tarName="$1"
shift
tarList="$@"
CMD="tar -cvf $tarName $tarList"
echo $CMD; $CMD
