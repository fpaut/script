#! /bin/bash
echo "List projects and their associated directories"
echo "#1 = project (optionnal, default is all projects)"
echo "-----------------------------------------------------------------------------------------------"
echo;echo
set -u
PROJECT_LIST=$1
CMD='$REPO list '$PROJECT_LIST
echo $CMD
eval $CMD
