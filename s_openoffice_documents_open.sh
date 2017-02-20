#!/bin/bash
cd $HOME/Documents
read -p "Recent documents erased? (y/n)?"
if [ $REPLY == "y" ]; then
	for f in $(find . -iname "*.odt"); do echo "$f"; xdg-open "$f"; done; for f in $(find . -iname "*.doc"); do echo "$f"; xdg-open "$f"; done
fi
