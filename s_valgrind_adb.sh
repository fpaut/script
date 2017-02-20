#!/bin/bash
VCMD=$1
CMD="adb shell /data/local/Inst/bin/valgrind --trace-children=yes --leak-check=full --keep-stacktraces=alloc-and-free $VCMD"
echo $CMD
eval $CMD
