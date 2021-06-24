#!/bin/bash
echo
echo -e $YELLOW"In .BASH_TOOLS"$ATTR_RESET

shopt -s expand_aliases
SIG_LIST="EXIT SIGTSTP SIGTTIN SIGTTOU"
export false=0
export FALSE=0
export true=1
export TRUE=1


## Convert HEX to DEC, invert of x0()
0x() 
{ 
	val=$1
	printf "%d\n" 0x$val
}
export -f 0x

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

bash_show_shell_opened_files()
{
	cmd="$@ | strace bash -li |& grep '^open'"
	echo $cmd; eval "$cmd"
}
export -f bash_show_shell_opened_files

beep()
{
	CMD="play -q -n synth 0.1 sin 880 || echo -e "\a""
	echo $CMD; eval "$CMD"
}

# Tests if the value is within an interval 
#
#eg.: if [[ "$(between 3 1 5)" == "1" ]]; then echo Yes, 3 is within 1 and 5; fi
between()
{
    value=$1
    min=$2
    max=$3
    if [[ "$value" -ge "$min" && "$value" -lt "$max" ]]; then
        echo 1
    else
        echo 0
    fi
}

## Simple bash calculator (need bash calculator 'bc' tool)
c_float()
{
	decimal_digit=4
	formula=${@}
	formula_str="scale=$decimal_digit; $formula"
	echo "$formula_str" | bc -l
}

## Simple bash calculator (without bash calculator 'bc' tool)
c_dec()
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
  eval "pushd ${the_new_dir} > /dev/null"
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
	test=$(echo ${myarray[@]} | grep --color=never -w $search)
	if [[ "$test" != "" ]]; then
		echo 1;
		return 0
	fi
	echo 0
	return 1
}

# save cursor position
cursor_pos_save()
{
	echo -e "\033[s"
}
export cursor_pos_save

# restore cursor position
cursor_pos_rest()
{
	echo -en "\033[u"
}
export cursor_pos_rest

	
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

debug_log() {
	string="$@"
	if [[ "$DEBUG_BASH" = "1" ]]; then
        	echo -en $YELLOW> /dev/stderr
        	echo -e $string$ATTR_RESET> /dev/stderr
        	return 1
    	else
        	return 0
	fi
}


def_font_attributes() {
	export PS1_UNDERLINED="\[\e[0;4m\]"

	export PS1_FONT_BOLD="\[\e[0;1m\]"

	export PS1_BKG_RED="\[\e[0;41m\]"
	export PS1_BKG_GREEN="\[\e[0;42m\]"
	export PS1_BKG_BLUE="\[\e[0;44m\]"

	export PS1_BLACK="\[\e[0;30m\]"
	export PS1_RED="\[\e[0;91m\]"
	export PS1_GREEN="\[\e[0;92m\]"
	export PS1_YELLOW="\[\e[0;93m\]"
	export PS1_BLUE="\[\e[0;34m\]"
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

	export UNDERLINED=$(tput smul)
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
	
	export BKG_BLACK=$(tput setab $TPUT_BLACK)
	export BKG_RED=$(tput setab $TPUT_RED)
	export BKG_GREEN=$(tput setab $TPUT_GREEN)
	export BKG_YELLOW=$(tput setab $TPUT_YELLOW)
	export BKG_BLUE=$(tput setab $TPUT_BLUE)
	export BKG_CYAN=$(tput setab $TPUT_CYAN)
	export BKG_MAGENTA=$(tput setab $TPUT_MAGENTA)
	export BKG_WHITE=$(tput setab $TPUT_WHITE)
	
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

exec() {
    CMD="$@"
    echo -e $UNDERLINED$BLUE"$CMD"$ATTR_RESET > /dev/stderr
	eval "$CMD"
}

exit_on_error()
{
    [[ "$1" != "" ]] && err="$1"
    [[ "$1" == "" ]] && err="$?"
    [[ "$err" != "0" ]] && echo -e EXIT_ON_ERROR=$err && exit $err
}

#
# Filename manipulation
#

# Return only extension of the filename provided (eg.: "/home/user/toto.txt.doc" return "doc")
file_get_ext()
{
	f="$@"
	filename=$(file_get_fullname "$f")
	#remove last '"'; if any
	filename=${filename%%\"*}
	if [[ $filename == *"."* ]]; then
		echo ${filename##*.}
	else
		return
	fi
}

 file_count_line() 
 {
	folder="$1"
	min_line_nb="$2"
	find $folder -exec ls -ld $PWD/{} \; | egrep -v "\.git|\[" | while read line
	do
		file="/${line#*/}"
		if [[ -f "$file" ]]; then
			COUNT=$(wc -l $file)
			COUNT=${COUNT% *}
			if [[ "$COUNT" -gt "$min_line_nb" ]]; then
				echo "$file:$COUNT"
			fi
		fi
	done
}
 
# Return filename+extension of a provided path+filename (eg.: "/home/user/toto.txt.doc" return "toto.txt.doc")
file_get_fullname()
{
	f="$@"
	echo $(basename "$f")
}

# Return only name of the filename provided without extension (eg.: "/home/user/toto.txt" return "toto")
file_get_name()
{
	f="$@"
	filename=$(file_get_fullname "$f")
	echo ${filename%.*}
}

# Return path of provided path+filename (eg.: "/home/user/toto.txt.doc" return "/home/user")
file_get_path()
{
	f="$@"
	path=$(dirname "$f")
	if [[ "$path" == "" ]]; then
		path="./"
	fi
	echo $path
}

# Return size in byte of a file
file_get_size()
{
	f="$@"
	stat --printf="%s" "$f"
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
	CMD="grep --color=never -E \"$pattern\" $filename | grep --color=never -Ev \"$expattern\""
	echo $CMD
	eval $CMD
}

get_caller() {
	var="$(ps | grep "$PID" | head -n 2)"
	caller=$(echo -e "${var##*/}")
	echo SCRIPT CALLED FORM \'$caller\'
	which $caller
}


gexport () {
	local pattern=$1
	eval "export | grep -i --color=never $pattern"
}

ghexdiff()
{
    a="$(basename "$1")" ;
    b="$(basename "$2")" ;
    hd "$1" > /tmp/"$a".hex ;
    hd "$2" > /tmp/"$b".hex ;
    meld /tmp/"$a".hex /tmp/"$b".hex ;
    rm /tmp/"$a".hex /tmp/"$b".hex ;
}

hexdump() {
	HD=$(which xxd)
	if (( $# == 0 )) ; then
		# Get pipe input
        eval "$HD < /dev/stdin"
        echo
    else
		# Get standart command line parameters
        eval "$HD \"$@\""
        echo
    fi
#	For hexdump tool
#	eval "$HD -e '$OPTIONS1' -e '$OPTIONS2' \"$@\""
#	OPTIONS1='8/1 "%02X ""\t"" "'
#	OPTIONS2='8/1 "%c""\n"'
}

isprint()
{
    char=$1
    echo $char
    if [[ "$char" -ge \\x20 && "$char" -le \\x7E ]]; then
        echo 1
        return 1
    else
        echo 0
        return 0
    fi
}
export isprint

unalias ll 2>/dev/null
ll() {
	path=$1
	pattern=$2
	case "$#" in
		0)
			path="."
			pattern=""
		;;
		1)
			path=$1
			pattern=""
		;;
		2)
			path=$1
			pattern=$2
		;;
		*)
			echo "Unknown machine ($HOSTNAME), or no bash specificities"
		;;
	esac
	if [[ "$pattern" == "" ]]; then
		ls --color=always --time-style=+"%b-%d-%Y %R:%S" -halF "$path"
	else
		ls --color=always --time-style=+"%b-%d-%Y %R:%S" -halF "$path" | grep --color=always "$pattern"
	fi
}

# Log a text on screen
logscreen_only()
{
    echo -e $@ > /dev/stderr
}
export logscreen_only

# Log an error on screen (in red)
logscreen_only_err()
{
    logscreen_only -n $RED
    logscreen_only $@
    logscreen_only -e $ATTR_RESET
}
export logscreen_only_err


# Log a text on screen (in cyan) and add it to logfile
logfile()
{
    # Checks than env var LOGFILE is well defined
    [[ "$LOGFILE" == "" ]] && echo -e $RED"LOGFILE undefined, nothing logged in file!"$ATTR_RESET
    logscreen_only -n $CYAN
    logscreen_only -n $@
    logscreen_only -e $ATTR_RESET
    [[ "$LOGFILE" != "" ]] && echo "$@" >> $LOGFILE
}
export logfile

# Log an error on screen (in red) and add it to logfile
logfile_err()
{
    # Checks than env var LOGFILE is well defined
    [[ "$LOGFILE" == "" ]] && echo -e $RED"LOGFILE undefined, nothing logged in file!"$ATTR_RESET
    logscreen_only_err $@
    [[ "$LOGFILE" != "" ]] && echo "$@" >> $LOGFILE
    [[ "$LOGFILE" != "" ]] && echo >> $LOGFILE
}
export logfile_err


# Add a text to logfile
logfile_only()
{
    # Checks than env var LOGFILE is well defined
    [[ "$LOGFILE" == "" ]] && echo -e $RED"LOGFILE undefined, returns!"$ATTR_RESET && kill -INT $$
 #   echo $@ >> $LOGFILE
}
export logfile



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

pad_number()
{
    number=$1
    maxPadLen=$2
	if [[ "${#number}" -ge "$maxPadLen" ]]; then
		echo $number
		return
	fi
#	echo "pad_number() number=$number" > /dev/stderr
	#Remove 0 avoiding octal interpretation and error "-bash: printf: 08: invalid octal number"
	OFF=0
	while [[ "${number:$OFF:1}" == "0" ]];
	do
		OFF=$(($OFF + 1))
	done
	number=${number:$OFF}
    fmt="%0"
    fmt+=$maxPadLen
    fmt+="d"
#	echo "pad_number() number=$number" > /dev/stderr
#	echo "pad_number() maxPadLen=$maxPadLen" > /dev/stderr
	if [[ "$maxPadLen" != "0" ]]; then
		printf "$fmt" $number
	else
		echo $number
	fi
}

prompt_update() {
	history -a
	repoGit=$(get_git_folder)
	gitps1_update_branch $repoGit
	gitps1_update_aheadBehind $repoGit
	gitps1_update_stash $repoGit
	ps1_prefix
	PS1=$PS1_PREFIX
	# Restore color after an input command
	trap 'echo -ne "\e[0m"' DEBUG
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
	# All input command will be yellow
	PS1_PREFIX=$PS1_PREFIX"> $PS1_YELLOW"
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

show_bad_encoding()
{
	FILE="$1"
	CMD="pcregrep --color='auto' -n '[^\x00-\x7F]' $FILE"
	echo $CMD
	eval "$CMD"
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
        ps fax | grep --color=never -i $ppid 2>&1  | egrep -v "grep|COMMAND"
    done
}

str_contains() {
	pattern="$1"
	str="$2"
	if echo "$str" | grep -iqF "$pattern"; then
		echo 1
		return 1
	else
		echo 0
		return 0
	fi
}

# Variable extraction
str_get_left_first()
{
	sep="$1"
	echo sep="\"$sep\""
	line="$2"
	echo line="\"$line\""
	echo ${line%$sep*}
}

# Variable extraction
str_get_left_last()
{
	sep="$1"
	line="$2"
	echo ${line%%$sep*}
}

# Variable length
str_get_length()
{
	var="$1"
	echo ${#var}
}

# Variable extraction
str_get_right_first()
{
	sep="$1"
	line="$2"
	echo ${line#*$sep}
}

# Variable extraction
str_get_right_last()
{
	sep="$1"
	line="$2"
	echo ${line##*$sep}
}

str_replace() {
	str=$1
	search=$2
	replace=$3
	result=${str//$2/$3}
	echo $result
}
export -f str_replace

# String padding on the left
str_pad_left() {
    str="$1"
    padLen="$2"
    char="$3"
    str_len=${#str}
    # if string longer then pad length, return string
	if [[ "$str_len" -ge "$padLen" ]]; then
		echo $str
		return
	fi
    # otherwise, create a string of padding char of (pad length) - (string length)
    pad_char_length=$(($padLen - $str_len))
    
    format="$char%.0s"
    result=$(eval "printf $format {1..$pad_char_length}")
    result+=$str
    echo $result
}
export -f str_pad_left

# String padding on the right
str_pad_right() {
    str="$1"
    padLen="$2"
    char="$3"
    str_len=${#str}
    # if string longer then pad length, return string
	if [[ "$str_len" -ge "$padLen" ]]; then
		echo $str
		return
	fi
	echo -e $RED"TODO: str_pad_right() not developped now!!"$ATTR_RESET > /dev/stderr
	return 1
}
export -f str_pad_right


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

wsource() {
	local path=$(which $1)
	CMD="source $path"; echo $CMD; $CMD
}


wll() {
	local path=$(which $1)
	CMD="ls -halF --color=auto $path"; echo $CMD; $CMD
	echo $(conv_path_for_win $path)
	echo
}

## Convert DEC to HEX, invert of 0x()
x0() 
{ 
	val=$1
	printf "%x\n" $val
}

## manpage using yelp
yman() 
{ 
	cmd="$1"
	yelp man:$cmd 2>/dev/null &
}


############################################################
## Background 
############################################################

echo -e $YELLOW"Out of .BASH_TOOLS"$ATTR_RESET
