#! /bin/bash
#
function def_color {
## Color definition
  CL_RESTORE='\033[0m'

  CL_RED='\033[00;31m'
  CL_GREEN='\033[00;32m'
  CL_YELLOW='\033[00;33m'
  CL_BLUE='\033[00;34m'
  CL_PURPLE='\033[00;35m'
  CL_CYAN='\033[00;36m'
  CL_LIGHTGRAY='\033[00;37m'

  CL_LRED='\033[01;31m'
  CL_LGREEN='\033[01;32m'
  CL_LYELLOW='\033[01;33m'
  CL_LBLUE='\033[01;34m'
  CL_LPURPLE='\033[01;35m'
  CL_LCYAN='\033[01;36m'
  CL_WHITE='\033[01;37m'
}

function init {
  def_color
## init() code
  log "deleting folder" $REPO
  rm -rf $REPO
  log "cloning "$REPO" from fork"
  git-log clone https://fpaut@github.com/fpaut/$REPO.git
  log "entering in folder "$REPO", adding 'upstream' remote, and synchronizing from fork (origin)"
  cd $REPO
  git-log remote add upstream https://github.com/01org/$REPO.git
  git-log pull origin
  FORK=$(git config --get remote.origin.url)
  CURRENT_BRANCH=$(git branch | grep "*" | sed "s/* //")
  LOCAL_BRANCHES=$(git branch | sed "s/* //")
  REMOTE_BRANCHES=$(git branch -a | grep "remotes/origin" | grep -v "HEAD" | sed "s/remotes//g" | sed "s/origin//g" | sed "s/\///g")
  echo "FORK= " $FORK
  echo "CURRENT_BRANCH= " $CURRENT_BRANCH
  echo "LOCAL_BRANCHES= " $LOCAL_BRANCHES
  echo "REMOTE_BRANCHES= " $REMOTE_BRANCHES
  echo "---------------------------------------------" && echo
}


function log {
  echo -e $CL_BLUE">>>>>  "$@
} 

function git-log {
  log "git "$@  $CL_RESTORE
  git $@
} 

function main {
  ABORT_ALLWAYS=0
  BRANCH_NOT_SYNCHED=""
  ## Force master branch as first branch to sync
  REMOTE_BRANCHES="master "$REMOTE_BRANCHES
  echo "REMOTE_BRANCHES= " $REMOTE_BRANCHES
   for BRANCH in $REMOTE_BRANCHES
  do
    log "creating local branch "$BRANCH
    git-log checkout -b $BRANCH
    ERR=$?
    log "synchronizing branch "$BRANCH
    git-log fetch origin $BRANCH
    ERR=$?
    if [ $ERR -ne 0 ]; then
      git-log diff
      if [ $ABORT_ALLWAYS != "1" ]; then
	log $CL_RED"ERR="$ERR ", Merge conflict on branch '"$BRANCH"' abort merge and continue (a)llways, Just this branch (ENTER) or (e)xit? > "
	BRANCH_NOT_SYNCHED=$BRANCH_NOT_SYNCHED","$BRANCH 
	read -p ""
      fi
      if [ $ABORT_ALLWAYS == "1" ]; then
	BRANCH_NOT_SYNCHED=$BRANCH_NOT_SYNCHED","$BRANCH
      fi
      if [ $REPLY"x" == "ax" ]; then
	ABORT_ALLWAYS=1
      fi
      if [ $REPLY"x" == "ex" ]; then
	exit
      fi
      git-log rebase --abort
    fi
    echo
  done

  git-log checkout $CURRENT_BRANCH
  log $CL_RED"Branch not synchronized due to merge conflict: "$BRANCH_NOT_SYNCHED
}



#########################################################################################################
#### MAIN
REPO=$1
init
main
cd $REPO

