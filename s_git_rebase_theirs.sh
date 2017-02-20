#!/bin/bash
BRANCH=$1
if [ "$BRANCH" = "" ]; then
	echo "rebase with merge strategy = 'accept theirs'"
	echo "#1 is branch of rebase"
	exit 1
fi
git rebase -s recursive -X theirs "$BRANCH"
