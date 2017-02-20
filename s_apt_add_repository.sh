#!/bin/bash
APT_REPO=$@
history_file=~/pkg_repository.txt
history_installed=$(cat $history_file)

contains() {
	local search=$1
	local myarray=$2
	case "${myarray[@]}" in  *$search*) echo true; return 1;; esac
	return 0
}

for repository in $APT_REPO
do
	echo "Check if $repository already installed..."
	if [ "$(contains "$repository" "$history_installed")" != "" ]; then
		echo "$repository already installed..."
	else
		echo "installing $repository"
		CMD="sudo add-apt-repository $repository"
		echo $CMD
		$CMD
		if [ "$?" = "0" ]; then
			echo -en "$CMD\n" >> $history_file
		else
			echo "$CMD failed\n"
			exit 1
		fi
	fi
done
