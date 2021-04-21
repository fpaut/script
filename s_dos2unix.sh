#!/bin/bash
echo Convert end of line of script files to unix format
cd $SCRIPTS_PATH
ls | while read file
do
    if [[ -f "$file" ]]; then 
        ASCII=$(file "$file" | egrep "ASCII|Bourne-Again|UTF-8|Perl|HTML")
        if [[ "$ASCII" != "" ]]; then
            echo -en $GREEN"$file:  "$CYAN; dos2unix "$file"; echo -n $ATTR_RESET
            
        fi
    fi
done
cd -
echo Convert end of line of SSH files to unix format
cd $HOME/.ssh
ls | while read file
do
    if [[ -f "$file" ]]; then 
        ASCII=$(file "$file" | egrep "ASCII|Bourne-Again|UTF-8|Perl|HTML")
        if [[ "$ASCII" != "" ]]; then
            echo -en $GREEN"$file:  "$CYAN; dos2unix "$file"; echo -n $ATTR_RESET
        fi
    fi
done
cd -

