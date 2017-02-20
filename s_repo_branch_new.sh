#! /bin/bash
set -u

print_usage() {
	echo "Begins a new branch for development, starting from the revision specified in the manifest"
	echo "#1 = branch name"
	echo "#2 = project list (optionnal, default is current working directory)"
	echo "-----------------------------------------------------------------------------------------------"
	echo;echo
}

print_usage
if [ "$#" -le "0" ]; then
	exit 1
fi

BRANCH_NAME=$1
PROJECT_LIST=$2
if [ ! $PROJECT_LIST ]; then
  PROJECT_LIST='.'
fi
echo "Be sure current branch is syncronized"
CMD='git pull'
echo $CMD
eval $CMD
CMD="$REPO start $BRANCH_NAME $PROJECT_LIST"
echo $CMD
eval $CMD
echo $BRANCH_NAME > ./branch_selected.log
