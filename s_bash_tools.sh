#!/bin/bash
shopt -s expand_aliases
alias exit_on_error='err=$?; [[ "$err" != "0" ]] && exit $err'
alias return_on_error='err=$?; [[ "$err" != "0" ]] && return $err'
SIG_LIST="EXIT SIGTSTP SIGTTIN SIGTTOU"

backtrace() {
  local frame=0
  echo "DIE"

  while caller $frame; do
    ((frame++));
  done

  echo "$*"
#  exit 1
}

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
	ATTR_UNDERLINED="\e[4m"

	FONT_BOLD="\e[1m"

	BKG_RED="\e[41m"
	BKG_GREEN="\e[42m"
	BKG_BLUE="\e[44m"

	BLACK="\e[30m"
	RED="\e[91m"
	GREEN="\e[92m"
	YELLOW="\e[93m"
	BLUE="\e[34m"
	CYAN="\e[96m"
	WHITE="\e[97m"

	ATTR_RESET="\e[0m"
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
	local myarray=$2
	case "${myarray[@]}" in  *$search*) echo 1; return 0;; esac
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
	echo -e $FONT_BLUE"$CMD"$ATTR_RESET
	OUT=$(eval "$CMD")
	ERR=$?
	if [ "$OUT" != "" ]; then
		echo $"$OUT"
	fi
	return $ERR
}
