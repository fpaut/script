#! /bin/bash
if [ "x"$1 == "x" ]; then
  dir="."
else
  dir=$1
fi

echo 'searching broken link in ' $dir
find $dir -type l ! -exec test -r {} \; -print

