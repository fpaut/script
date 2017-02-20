#!/bin/bash
eventsList=("access" "modify" "attrib" "close_write" "close_nowrite" "close" "open" "moved_to" "moved_from" "move" "create" "delete" "delete_self" "unmount")
events=$1
shift
folder=$@
cmd="inotifywait "

containsElement () {
  local e
  for e in "${@:2}"; do [[ "$e" == "$1" ]] && echo true; done
}

if [ ! $(containsElement "$events" "${eventsList[@]}") ]; then
    echo "no parameters, all events will be monitored"
    folder=$events
    cmd=$cmd"-rm $folder"
else
    cmd=$cmd"-rme $events $folder"
fi
echo $cmd
$cmd
