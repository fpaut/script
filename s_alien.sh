#!/bin/sh
FILE=$@
SIZE=$(stat -c %s $FILE)
echo "FILE=$FILE"
echo "SIZE=$(($SIZE / 1024 ))KB"

CMD="alien --verbose --scripts $@"; echo $CMD; $CMD
CMD="chown $USER:$USER $@"; echo $CMD; $CMD
