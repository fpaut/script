#! /bin/bash
~/bin/scripts/checkpatch.pl --no-tree --show-types --ignore "NEW_TYPEDEFS,LINE_CONTINUATIONS,POINTER_LOCATION,SPACING" -f $1
# ~/bin/scripts/checkpatch.pl --no-tree --show-types --ignore "" -f $1


