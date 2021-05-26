#!/bin/bash
echo Convert end of line of script files to unix format
echo "cd $SCRIPTS_PATH"
cd $SCRIPTS_PATH
ls -a | while read file
do
    if [[ -f "$file" ]]; then 
        ASCII=$(file "$file" | egrep "ASCII|Bourne-Again|UTF-8|Perl|HTML")
        if [[ "$ASCII" != "" ]]; then
            dos2unix "$file"
        fi
    else
        echo -en $MAGENTA"$file not ASCII"; echo -n $ATTR_RESET
        echo
    fi
done
cd -
echo "cd -"
echo Convert end of line of SSH files to unix format
cd $HOME/.ssh
echo "cd $HOME/.ssh"
ls -a | while read file
do
    if [[ -f "$file" ]]; then 
        ASCII=$(file "$file" | egrep "ASCII|Bourne-Again|UTF-8|Perl|HTML")
        if [[ "$ASCII" != "" ]]; then
            dos2unix "$file"
        fi
    fi
done
cd -
echo "cd -"

