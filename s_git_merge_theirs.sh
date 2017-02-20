#!/bin/bash
BRANCH=$1
if [ "$BRANCH" = "" ]; then
	echo "merge strategy = 'accept theirs'"
	echo "#1 is branch of rebase"
	exit 1
fi
CMD="git merge --strategy=recursive -X theirs $BRANCH"
echo $CMD
$CMD
