#!/bin/bash
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

debug_log() {
	string=$@
	if [[ "$DEBUG_BASH" != "" ]]; then
		echo $string
	fi
}

double_backslash()
{
	str="$1"
	echo $(echo $str |  sed 's,\\,\\\\,g')
}
export -f double_backslash

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

set_term_title() {
  local TITLE=$@
  echo -ne '\033]0;'$TITLE'\007'
}

contains() {
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

c_exec () {
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
