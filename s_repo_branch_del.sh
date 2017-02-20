#! /bin/bash
set -u
print_usage() {
	echo "Abandons a development branch by deleting it (and all its history)"
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
CMD='$REPO abandon '$BRANCH_NAME' '$PROJECT_LIST
echo $CMD
eval $CMD
echo $BRANCH_NAME > ./branch_selected.log
