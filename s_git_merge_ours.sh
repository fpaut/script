#!/bin/bash
BRANCH=$1
if [ "$BRANCH" = "" ]; then
	echo "merge strategy = 'accept ours'"
	echo "#1 is branch of merge"
	exit 1
fi
git merge -s ours "$BRANCH"
