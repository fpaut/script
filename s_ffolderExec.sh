#! /bin/bash
reqDir=$1
pattern=$2
command=$3
curr_path=$(pwd)
echo 'searching folder containing pattern :' $pattern ' in folder' $reqDir ' and execute on each the command ' $command
CMD='find '$reqDir' -type d | grep "'$pattern'"'
FIND=$(eval $CMD)
echo "Executing "$CMD
for folder in '$FIND'; do
  export FOLDER=$folder
  echo "Find FOLDER=$folder, execute $exec";
  eval "$exec" ;
done

  exec=${command/FOLDER/$curr_path/$FOLDER}