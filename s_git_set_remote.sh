#! /bin/bash
NEW_URL=$1
TEMPLATE=$2
TITLE=$3

contains() {
	local search=$1
	local myarray=$2
	case "${myarray[@]}" in  *$search*) echo true; return ;; esac
}



# Update ~/.gitconfig
if [ "$NEW_URL" != "" ]; then
	NEW_URL="${NEW_URL//\//\\/}"
fi
CMD="rm ~/.gitconfig"
echo $CMD
eval $CMD
CMD="cp $HOME/bin/scripts/.gitconfig_base ~/.gitconfig"
echo $CMD
eval $CMD
if [ "$TITLE" != "" ]; then
	echo >> ~/.gitconfig
	echo "## $TITLE" >> ~/.gitconfig
fi
if [ "$NEW_URL" != "" ]; then
	URL="ssh:\/\/$NEW_URL"
	CMD="sed 's/URL_TO_REPLACE/$URL/g' $HOME/bin/scripts/$TEMPLATE >> ~/.gitconfig"
	echo $CMD
	eval $CMD
fi

