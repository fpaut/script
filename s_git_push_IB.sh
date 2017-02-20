#!/bin/bash
IB=$1
if [ "$IB" = "" ]; then
	echo "#1 is Ingredient Branch name"
	exit 1
fi
CMD="git push sp HEAD:refs/for/private/topic/sp/$IB"
echo $CMD
$CMD
