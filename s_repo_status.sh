#! /bin/bash
source s_bash_tools.sh; def_font_attributes
echo "Compares the working tree to the staging area (index) and the most recent commit on this branch"
echo "#1 = project list (optionnal, none show the working tree status)"
echo "-----------------------------------------------------------------------------------------------"
echo;echo
set -u
PROJECT_LIST=$1
c_exec "$REPO status "$PROJECT_LIST
