#!/bin/sh
FILE=$@
SIZE=$(stat -c %s $FILE)
echo "FILE=$FILE"
echo "SIZE=$(($SIZE / 1024 ))KB"

CMD="alien --scripts $@"
echo $CMD
$CMD
