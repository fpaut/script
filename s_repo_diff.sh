#! /bin/bash
set -u
echo "Shows outstanding changes between commit and working tree"
echo "#1 = project list (optionnal, default is current working directory)"
echo "-----------------------------------------------------------------------------------------------"
echo;echo
PROJECT_LIST=$1
if [ ! $PROJECT_LIST ]; then
  PROJECT_LIST='.'
fi
CMD='$REPO diff '$PROJECT_LIST
echo $CMD
eval $CMD
