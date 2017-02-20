#! /bin/bash
set -u

PROJECT=$1
# source s_bash_tools.sh; def_font_attributes
echo "To see a list of existing branches"
echo "-----------------------------------------------------------------------------------------------"
echo;echo
CMD="$REPO branches $PROJECT"
echo $CMD
eval $CMD
