#!/bin/bash
header_file="./Main_IA_EEPROM.h"
websettings_file="../../../../ReglagesHTML/settings.csv"
regex_pattern="(.*EEINDEX_)"
# Exclude pattern could be combined using OR ('|')
exclude_pattern="EEINDEX_IA|//.*EEINDEX_|DUMMY"
if [[ "$#" == "0" ]]; then
	echo "usage :"
	echo "Extract NVM seiings from '$header_file' to :"
	echo "Parameters :"
	echo "#1 : 'check' or 'add'"
	echo "     'check' : list the NVM parameters missing as websettings parameters (file: $websettings_file)"
	echo "     'add'   : add the missing nvm parameters in the websettings file: '$websettings_file'"
	echo " #2 : Header file path (default=$header_file)"
	echo " #3 : Websettings file path (default=$websettings_file)"
	exit
fi

#############################################################
##### LOCAL FUNCS
#############################################################
cb_show() {
	param=$1
	echo -e "$param"
}

cb_add() {
	param=$1
	## immu;main;IA_MeasCycle;;opentrashrail;Allows throw a cuvette in the trash;EEINDEX_MEAS_CYCLE_OPEN_TRASH_RAIL;LEDappli\FSM_IA.set;;__FSM_IA_MEASCYCLE__
	echo -e "Adding '$param' to $websettings_file"
	echo -e "module;device;target;subdevice;keyword;text;$param;C file;JS filter;JS tag" >> $websettings_file
}


search_missing_nvm() {
	cb=$1
	echo "Searching missing NVM parameters in the WebSettings...(Parsing $header_file and comparing with content of $websettings_file)" > /dev/stderr
	cat $header_file | egrep $regex_pattern | egrep -v $exclude_pattern | while read input; do
			input=${input% =*}
			input=${input%,*}
			exist=$(cat $websettings_file | grep $input)
			if [[ "$exist" == "" ]]; then
				$cb "$input"
			fi
	done
}

#############################################################
action=$1
[[ "$2" != "" ]] && header_file=$2
[[ "$3" != "" ]] && websettings_file=$3

case $action in
	check)
		nvm_missing=$(search_missing_nvm cb_show)
		if [[ "$nvm_missing" != "" ]]; then
			echo "The following parameters are missing in the Web settings file '$websettings_file'" > /dev/stderr
			echo -e "$nvm_missing"
		else
			echo "No NVM parameters are missing"
		fi
		;;
	add)
		search_missing_nvm cb_add
		;;
	*)
		echo "Unknown action '$action'"
		exit
		;;
  esac


