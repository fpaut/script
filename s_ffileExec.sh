#! /bin/bash
# SVG_IFS=$IFS
#IFS=""
source ~/bin/scripts/s_bash_tools.sh

reqDir=$1
pattern=$2
command=$3
def_font_attributes
echo 'searching file containing pattern :' $pattern ' in folder' $reqDir ' and execute on each the command ' $command
exec=${command//'FILE'/"{}"}
LOG_RESULT=$(pwd)/fileFound_result.log
CMD="find $reqDir -iname \"$pattern\" -print0 -fprint0 "$LOG_RESULT" -type f -exec $exec \;"

### find . -name "*.txt" -exec echo {} \; -exec grep banana {} \;


echo "CMD="$CMD
eval $CMD
# echo -e $FIND > $LOG_RESULT

# for file in $FIND; do
#  echo "Command before '$command'"
#  echo "Command after '$exec'"

#   RESULT=$(eval $exec)
#   if [[ "$RESULT" != "" ]]; then
#     echo -e $YELLOW"in "$file
#     echo -en $GREEN$RESULT$ATTR_RESET
#     echo
#   fi
# done
# IFS=$SVG_IFS




