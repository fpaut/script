#!/bin/bash
echo
echo In BASHRC_TOOLS
shopt -s expand_aliases
alias exit_on_error='err=$?; [[ "$err" != "0" ]] && exit $err'
alias return_on_error='err=$?; [[ "$err" != "0" ]] && return $err'
SIG_LIST="EXIT SIGTSTP SIGTTIN SIGTTOU"

## Convert HEX to DEC
0x() 
{ 
	val=$1
	printf "%d\n" 0x$val
}


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

backslash_to_slash()
{
	str="$1"
	echo $(echo $str |  sed 's,\\,/,g')
}
export -f backslash_to_slash

beep()
{
	CMD="play -q -n synth 0.1 sin 880 || echo -e "\a""
	echo $CMD; eval "$CMD"
}

## Simple bash calculator (need bash calculator 'bc' tool)
c()
{
	decimal_digit=4
	formula=${@}
	formula_str="scale=$decimal_digit; $formula"
	echo "$formula_str" | bc -l
}

## Simple bash calculator (without bash calculator 'bc' tool)
c_()
{
    echo "$((${@}))"
}

cd () {
	local path="$@"
	if [ "$path" = "" ]; then
		path=$HOME
	fi
##	if [ "$path" = "-" ]; then
##		popd 2>&1 1>/dev/null
##	else
##		pushd $path 2>&1 1>/dev/null
##	fi
	builtin cd "$path"
}


# 
# b) function cd_func
# This function defines a 'cd' replacement function capable of keeping, 
# displaying and accessing history of visited directories, up to 10 entries.
# To use it, uncomment it, source this file and try 'cd --'.
# acd_func 1.0.5, 10-nov-2004
# Petar Marinov, http:/geocities.com/h2428, this is public domain
cd_func ()
{
  local x2 the_new_dir adir index
  local -i cnt

  if [[ $1 ==  "--" ]]; then
    dirs -v
    return 0
  fi

  the_new_dir=$1
  [[ -z $1 ]] && the_new_dir=$HOME

  if [[ ${the_new_dir:0:1} == '-' ]]; then
    #
    # Extract dir N from dirs
    index=${the_new_dir:1}
    [[ -z $index ]] && index=1
    adir=$(dirs +$index)
    [[ -z $adir ]] && return 1
    the_new_dir=$adir
  fi

  #
  # '$HOME/' has to be substituted by ${HOME}
  [[ ${the_new_dir:0:1} == '$HOME/' ]] && the_new_dir="${HOME}${the_new_dir:1}"

  #
  # Now change to the new dir and add to the top of the stack
  pushd "${the_new_dir}" > /dev/null
  [[ $? -ne 0 ]] && return 1
  the_new_dir=$(pwd)

  #
  # Trim down everything beyond 11th entry
  popd -n +11 2>/dev/null 1>/dev/null

  #
  # Remove any other occurence of this dir, skipping the top of the stack
  for ((cnt=1; cnt <= 10; cnt++)); do
    x2=$(dirs +${cnt} 2>/dev/null)
    [[ $? -ne 0 ]] && return 0
    [[ ${x2:0:1} == '$HOME/' ]] && x2="${HOME}${x2:1}"
    if [[ "${x2}" == "${the_new_dir}" ]]; then
      popd -n +$cnt 2>/dev/null 1>/dev/null
      cnt=cnt-1
    fi
  done

  return 0
}

cdmtp() {
    userID=$(id $USER)
    userID=${userID#*uid=}
    userID=${userID%%($USER)*}
    cd /run/user/$userID/gvfs/mtp*
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

edit() {
    CMD="npp $(conv_path_for_win $@)&"
    echo $CMD
	$CMD&
}


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

###################################################
## filtered cat using pattern and excluded pattern
gcat() {
	filename="$1"
	pattern="$2"
	expattern="$3"
	if [[ "$@" == "" ]]; then
		echo ${FUNCNAME[0]} \"#1\" \"#2\" \"#3\" 
		echo "#1 filename"
		echo "#2 patterns (separate with '|' eg.:\"pattern1|pattern2|...\") (could be 'options+patterns')"
		echo "#3 pattern to exclude (separate with '|' eg.:\"exclude1|exclude2|...\") (could be 'options+patterns')"
		return 1
	fi
	CMD="grep -E \"$pattern\" $filename | grep -Ev \"$expattern\""
	echo $CMD
	eval $CMD
}

get_caller() {
	var="$(ps | grep "$PID" | head -n 2)"
	caller=$(echo -e "${var##*/}")
	echo SCRIPT CALLED FORM \'$caller\'
	which $caller
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

messageBox() {
	msg="$1"
    CMD="zenity --info --text=$msg"
    echo $CMD
	$CMD
}

monitor_folder(){
	return
	while true
	do
		MONITOR_PATH=$(pwd)
		echo "MONITOR_PATH=$MONITOR_PATH"
##		sleep 5
	done
}

notify() {
	msg="$1"
    CMD="notify-send $msg"
    echo $CMD
	$CMD
}

npp() {
    CMD="$(which notepadpp) \"$(conv_path_for_win $@)\""
    echo $CMD
	eval $CMD 2>/dev/null&
}

prompt_update() {
	history -a
	repoGit=$(get_git_folder)
	gitps1_update_branch $repoGit
	gitps1_update_aheadBehind $repoGit
	gitps1_update_stash $repoGit
	ps1_prefix
	PS1=$PS1_PREFIX
}

ps1_print() {
	echo "PS1=$PS1"
}

ps1_restore() {
	PS1=$PS1_SVG
}

ps1_prefix()
{
	IAM=$(whoami)

	PS1_PREFIX="\D{%T}-$PREF_COLOR\h(\u):$PS1_CYAN \w\n"
	if [[ "$IAM" != "root" ]]; then
		PREF_COLOR=$GREEN
	else
		PREF_COLOR=$RED
	fi
	if [[ "$BRANCH" != "" ]]; then
		PS1_PREFIX=$PS1_PREFIX"$PS1_CYAN[$BRANCH]$PS1_ATTR_RESET"
	fi
	if [[ "$GIT_AHEAD" != "" &&  "$GIT_AHEAD" != "0" ]]; then
		PS1_PREFIX=$PS1_PREFIX"$PS1_BLUE[ ┴ :$GIT_AHEAD]$PS1_ATTR_RESET"
	fi
	if [[ "$GIT_BEHIND" != "" &&  "$GIT_BEHIND" != "0" ]]; then
		PS1_PREFIX=$PS1_PREFIX"$PS1_BLUE[ ┬ :$GIT_BEHIND]$PS1_ATTR_RESET"
	fi
	## Stash specific to a branch (GIT_STASH_BRANCH)
	if [[ "$GIT_STASH" != "" ]]; then
		## 'Global' Stash (wathever the branch)
		if [[ "$GIT_STASH_BRANCH" != "" ]]; then
			PS1_PREFIX=$PS1_PREFIX"$PS1_RED[stash x $GIT_STASH_BRANCH]$ATTR_RESET"
		else
			PS1_PREFIX=$PS1_PREFIX"$PS1_BLINK[stash]$ATTR_RESET"
		fi
	fi
	PS1_PREFIX=$PS1_PREFIX"$PS1_ATTR_RESET> "
}

ps1_unset() {
  unset PS1
  ps1_prefix
  PS1="$PS1_PREFIX: "
}


#
# Some example functions:
#
# a) function settitle
settitle () 
{ 
  echo -ne "\e]2;$@\a\e]1;$@\a"; 
}

set_term_title() {
  local TITLE=$@
  echo -ne '\033]0;'$TITLE'\007'
}

show_parent()
{
    pid=$1
    if [[ "$pid" == "" ]]; then
        pid=$$
    fi
    
    echo pid=$pid
    ps -o ppid=$pid | while read ppid;
    do 
        ps fax | grep -i $ppid 2>&1  | egrep -v "grep|COMMAND"
    done
}

str_replace() {
	str=$1
	search=$2
	replace=$3
	result=${str//$2/$3}
	echo $result
}
export -f str_replace


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

upper_case()
{
	str=$1
	echo ${str^^}
}
export -f upper_case

wbdb() {
	local path=$(which $1)
	shift
	CMD="bashdb -x $HOME/.bashdbinit $path $@"; echo $CMD; $CMD
}

wcat() {
	local path=$(which $1)
	CMD="cat $path"; echo $CMD; $CMD
}

which() {
	local who="$@"
#	echo who before = $who
#	who=$(str_replace "$who" " " "\ ")
#	echo who after = $who
	paths=($(/bin/which -a "$who" 2>/dev/null))
	ERR=$?
	if [[ "$$ERR" == "0" ]]; then
        echo "${paths[$((${#paths[@]} - 1))]}"
        ERR=$?
	else
		echo "Error on which $who" > /dev/stderr
    fi
	if [[ "$ERR" != "0" ]]; then
		echo "Error on which $who" > /dev/stderr
    fi
}

wll() {
	local path=$(which $1)
	CMD="ls -halF --color=auto $path"; echo $CMD; $CMD
	echo $(conv_path_for_win $path)
	echo
}

## Convert DEC to HEX
x0() 
{ 
	val=$1
	printf "%x\n" $val
}

############################################################
## Background 
############################################################



echo Out of BASHRC_TOOLS
