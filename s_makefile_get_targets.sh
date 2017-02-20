#!/bin/bash
makefilePath="$@"
if [ "$makefilePath" == "" ]; then
	makefilePath="$ANDROID_BUILD_TOP/build/core/main.mk"
fi
SVG_IFS=$IFS
IFS=""
CMD="grep '^[^#[:space:]].*:' $makefilePath --color=always"
echo $CMD
echo -e $(eval $CMD)
IFS=$SVG_IFS

