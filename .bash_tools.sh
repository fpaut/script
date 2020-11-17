#!/bin/bash
echo
echo In BASHRC_TOOLS
shopt -s expand_aliases
alias exit_on_error='err=$?; [[ "$err" != "0" ]] && exit $err'
alias return_on_error='err=$?; [[ "$err" != "0" ]] && return $err'
SIG_LIST="EXIT SIGTSTP SIGTTIN SIGTTOU"

backslash_to_slash()
{
	str="$1"
	echo $(echo $str |  sed 's,\\,/,g')
}
export -f backslash_to_slash

backtrace() {
  local frame=0
  echo "DIE"

  while caller $frame; do
    ((frame++));
  done

  echo "$*"
#  exit 1
}

contains()
{
	if [ $# -le 1 ]; then
		echo "#1 is pattern"
		echo "#2 is array to check"
		return 1
	fi
	local search=$1
	local myarray=${@:2}
	test=$(echo ${myarray[@]} | grep -w $search)
	if [[ "$test" != "" ]]; then
		echo 1;
		return 0
	fi
	echo 0
	return 1
}

c_exec ()
{
	# $1=command to execute
	# $2=0 just to display xommand without execution
	local CMD=$1
	local EXEC=$2
	local ERR
	if [ "$EXEC" = "0" ]; then
		CMD="## $CMD"
	fi
	echo -e $BLUE"$CMD"$ATTR_RESET
	export OUT=$(eval "$CMD")
	ERR=$?
	return $ERR
}

datediff()
{
	if [[ "$1" == "" || "$2" == "" ]]; then
		echo #1 and #2 parameters must be 2 dates to calculate difference in days
		echo eg.: ${FUNCNAME[0]} '"9 oct" "now"'
		echo
		return 1
	fi
    d1=$(date -d "$1" +%s)
    d2=$(date -d "$2" +%s)
	echo $(( (((d1-d2) > 0 ? (d1-d2) : (d2-d1)) + 43200) / 86400 )) days
}

debug_log() {
	string=$@
	if [[ "$DEBUG_BASH" != "" ]]; then
		echo $string
	fi
}

def_font_attributes() {
	export PS1_ATTR_UNDERLINED="\[\e[0;4m\]"

	export PS1_FONT_BOLD="\[\e[0;1m\]"

	export PS1_BKG_RED="\[\e[0;41m\]"
	export PS1_BKG_GREEN="\[\e[0;42m\]"
	export PS1_BKG_BLUE="\[\e[0;44m\]"

	export PS1_BLACK="\[\e[0;30m\]"
	export PS1_RED="\[\e[0;91m\]"
	export PS1_GREEN="\[\e[0;92m\]"
	export PS1_YELLOW="\[\e[0;93m\]"
##	export PS1_BLUE="\[\e[0;34m\]"
	export PS1_BLUE="\[\e[34m\]"
	export PS1_CYAN="\[\e[0;96m\]"
	export PS1_WHITE="\[\e[0;97m\]"

	export PS1_DIMMED="\[\e[2m\]"
	export PS1_BLINK="\[\e[5m\]"
	
	export PS1_ATTR_RESET="\[\e[m\]"
	
	TPUT_BLACK=0
	TPUT_RED=1
	TPUT_GREEN=2
	TPUT_YELLOW=3
	TPUT_BLUE=4
	TPUT_MAGENTA=5
	TPUT_CYAN=6
	TPUT_WHITE=7
	TPUT_DEFAULT=9

	export ATTR_UNDERLINED=$(tput smul)
	export BLINK=$(tput blink)
	export BOLD=$(tput bold)
	
	export BLACK=$(tput setaf $TPUT_BLACK)
	export RED=$(tput setaf $TPUT_RED)
	export GREEN=$(tput setaf $TPUT_GREEN)
	export YELLOW=$(tput setaf $TPUT_YELLOW)
	export BLUE=$(tput setaf $TPUT_BLUE)
	export CYAN=$(tput setaf $TPUT_CYAN)
	export MAGENTA=$(tput setaf $TPUT_MAGENTA)
	export WHITE=$(tput setaf $TPUT_WHITE)
	
	export BKG_RED=$(tput setab $TPUT_RED)
	export BKG_GREEN=$(tput setab $TPUT_GREEN)
	export BKG_BLUE=$(tput setab $TPUT_BLUE)
	
	export ATTR_RESET=$(tput sgr0)
}

double_backslash()
{
	str="$1"
	echo $(echo $str |  sed 's,\\,\\\\,g')
}
export -f double_backslash


#
# Filename manipulation
#

# Return filename+extension of a provided path+filename (eg.: "/home/user/toto.txt.doc" return "toto.txt.doc")
file_get_fullname()
{
	f="$1"
	echo $(basename "$f")
}

# Return path of provided path+filename (eg.: "/home/user/toto.txt.doc" return "/home/user")
file_get_path()
{
	f="$1"
	path=$(dirname "$1")
	if [[ "$path" == "" ]]; then
		path="./"
	fi
	echo $path
}

# Return only name of the filename provided (eg.: "/home/user/toto.txt.doc" return "toto.txt")
file_get_name()
{
	f="$1"
	filename=$(file_get_fullname "$f")
	echo ${filename%.*}
}

# Return only extension of the filename provided (eg.: "/home/user/toto.txt.doc" return "doc")
file_get_ext()
{
	f="$1"
	filename=$(file_get_fullname "$f")
	#remove last '"'; if any
	filename=${filename%%\"*}
	if [[ $filename == *"."* ]]; then
		echo ${filename##*.}
	else
		return
	fi
}

# Return only extension of the filename provided (eg.: "/home/user/toto.txt.doc" return "doc")
replace()
{
	pattern1=$1
	pattern2=$2
	str=$3
	echo $(echo $str |  sed "s,$pattern1,$pattern2,g")
}


get_left_first()
{
	sep="$1"
	echo sep="\"$sep\""
	line="$2"
	echo line="\"$line\""
	echo ${line%$sep*}
}

get_left_last()
{
	sep="$1"
	line="$2"
	echo ${line%%$sep*}
}

get_right_first()
{
	sep="$1"
	line="$2"
	echo ${line#*$sep}
}

get_right_last()
{
	sep="$1"
	line="$2"
	echo ${line##*$sep}
}

lower_case()
{
	str=$1
	echo ${str,,}
}
export -f lower_case

trap_handler_cb() {
	# Backup exit status if you're interested...
    local exit_status=$?
    echo "TRAP HANDLER (CALLER=$(caller 0)"
} # trap_exit_handler()

trap_handler_set() {
	trap trap_handler_cb $SIG_LIST

	# nounset : Attempt to use undefined variable outputs error message, and forces an exit
	set -o nounset
}

trap_handler_unset() {
	trap "" $SIG_LIST

	# nounset : Attempt to use undefined variable outputs error message, and forces an exit
	set +o nounset
}

set_term_title() {
  local TITLE=$@
  echo -ne '\033]0;'$TITLE'\007'
}

upper_case()
{
	str=$1
	echo ${str^^}
}
export -f upper_case

echo Out of BASHRC_TOOLS
