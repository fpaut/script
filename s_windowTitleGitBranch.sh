#! /bin/bash
DELAY=3 # s
echo 'execute: '$CMD' every '$DELAY' seconds'
while true; do
  GET_TITLE=$(xwininfo -id $(xprop -root | awk '/NET_ACTIVE_WINDOW/ { print $5; exit }') | awk -F\" '/xwininfo:/ { print $2; exit }')
  DIR=$(pwd)
  GIT_BRANCH=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/[\1]/')
  WIN_TITLE=$GET_TITLE
  BRANCH=$GIT_BRANCH
  ALREADY_ADDED=$(echo $WIN_TITLE | grep -F $BRANCH)
  echo "WIN_TITLE="$WIN_TITLE
  echo "BRANCH="$BRANCH
  echo "'$ALREADY_ADDED''x'="$ALREADY_ADDED"x"
  
  if [ '$ALREADY_ADDED'"x" == "x" ]; then
    if [ '$WIN_TITLE'"x" != "x" ]; then
      if [ "x"'$BRANCH' != "x" ]; then
	WIN_TITLE=$WIN_TITLE" "$BRANCH
	echo "NEW WIN_TITLE="$WIN_TITLE
	xtitle -t $WIN_TITLE
      fi
    fi
  fi
  sleep $DELAY
done
