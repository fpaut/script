#! /bin/bash
set -u
echo "specify a revision, i.e., a particular manifest-branch"
echo "#1 Revision"
echo "-----------------------------------------------------------------------------------------------"
echo;echo
BRANCH_NAME=$@
if [ ! $BRANCH_NAME ]; then
  BRANCH_NAME$(cat ./branch_selected.log)
fi
CMD='$REPO init -b '$BRANCH_NAME
echo $CMD
eval $CMD
echo;echo;echo
echo "Don't forget : ' $REPO sync ' !"
