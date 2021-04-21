#!/bin/bash
#

SOURCE=$1 # source = 'upstream' or 'origin' (fork)
if [ $SOURCE != "upstream" ]; then
  if [ $SOURCE != "origin" ]; then
    exit
  fi
fi


function log {
  echo $@
} 

function gitLog {
  log "[branch :'"$BRANCH$"' >> git "$@
  git $@
  ERR=$?
  log "gitLog RETURN :"$ERR
  return $ERR
} 


function init {
  gitLog pull $SOURCE
  REPO_SRC=$(git config --get remote.$SOURCE.url)
  FORK=$(git config --get remote.origin.url)
  CURRENT_BRANCH=$(git branch | grep "*" | sed "s/* //")
  LOCAL_BRANCHES=$(git branch | sed "s/* //")
  REMOTE_BRANCHES=$(git branch -a | grep "remotes/"$SOURCE | grep -v "HEAD" | sed "s/remotes//g" | sed "s/"$SOURCE"//g" | sed "s/\///g")
}

function main {

  

  echo "REPO_SRC= " $REPO_SRC
  echo "FORK= " $FORK
  echo "CURRENT_BRANCH= " $CURRENT_BRANCH
  echo "LOCAL_BRANCHES= " $LOCAL_BRANCHES
  echo "REMOTE_BRANCHES(repo '"$SOURCE"')= " $REMOTE_BRANCHES
  echo "---------------------------------------------" && echo

  PUSH_ALLWAYS=0
  for BRANCH in $REMOTE_BRANCHES
  do
    if [ $BRANCH == "master" ]; then
      gitLog checkout $BRANCH
    else
      gitLog checkout -b $BRANCH $SOURCE/$BRANCH
    fi
    ERR=$?
    if [ !ERR ]; then
      gitLog fetch $SOURCE
      gitLog merge $SOURCE/$BRANCH
      ERR=$?
      if [ $ERR -eq 0 ]; then
	if [ $PUSH_ALLWAYS != "A" ]; then
	  if [ $PUSH_ALLWAYS != "N" ]; then
	    read -p "'"$BRANCH"' synched from '"$SOURCE"', ready to push '"$BRANCH"' on origin("=$FORK") (y/n/'A'llways/'N'ever)?"
	  fi
	fi
	PUSH_ALLWAYS=$REPLY
	if [ $REPLY == "y" ] || [ $PUSH_ALLWAYS == "A" ]; then
	  gitLog push 'origin '$BRANCH
	else
	  log "La branche "$BRANCH" n'a pas été mise à jour sur "$FORK
	fi
      else
	echo "Current branch is "$BRANCH
	read -p "Before continue or exit, abort merge? (y/n)?"
	if [ $REPLY == "y" ]; then
	  gitLog merge --abort
	fi
	read -p "Exit ? (y/n)?"
	if [ $REPLY == "y" ]; then
	  echo "before exit, current branch is "$BRANCH
	  exit
	fi
      
      fi
    fi
    echo
  done

  if [ $ERR -eq 0 ]; then
    gitLog checkout $CURRENT_BRANCH
  fi
}

init
main

