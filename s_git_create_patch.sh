#!/bin/bash
commit1=$1
commit2=$2
patchName=$3
if [[ "$commit1" == "" || "$commit2" == "" ]]; then
	echo "usage : $0 'Commit 1' 'Commit 2' 'Patch name'"
	exit 1
fi
if [[ "$patchName" == "" ]]; then
	patchName="my_awesome_change.patch"
	echo The patch file name will be named $patchName
fi
CMD="git diff $commit1 $commit2 > $patchName"
echo $CMD
eval "$CMD"