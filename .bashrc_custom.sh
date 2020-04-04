echo
echo In BASHRC_CUSTOM
# $HOME/.bashrc_custom : executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples


export PS1_SVG="$PS1"

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Aliases
#
# Some people use a different file for aliases
if [ -f "${HOME}/.bash_aliases" ]; then
   source "${HOME}/.bash_aliases"
fi

alias xopen="xdg-open"
# History control
#  ignore duplicate
HISTCONTROL=ignoredups
#  size
HISTSIZE=1000

#
# Some example functions:
#
# a) function settitle
settitle () 
{ 
  echo -ne "\e]2;$@\a\e]1;$@\a"; 
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

## Convert HEX to DEC
0x() 
{ 
	val=$1
	printf "%d\n" 0x$val
}

## Convert DEC to HEX
_x() 
{ 
	val=$1
	printf "%x\n" $val
}

## Simple bash calculator (need bash calculator 'bc' tool)
c()
{
	decimal_digit=4
	formula=${@}
	formula_str="scale=$decimal_digit; $formula"
	echo "$formula_str" | bc -l
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


double_backslash()
{
	str="$1"
	echo $(echo $str |  sed 's,\\,\\\\,g')
}
export -f double_backslash

###################################################
## filtered cat using pattern and excluded pattern
ecat() {
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

# Return filename+extension of a provided path+filename (eg.: "/home/user/toto.txt.doc" return "toto.txt.doc")
file_get_fullname()
{
	file="$1"
	echo $(basename "$file")
}

# Return path of provided path+filename (eg.: "/home/user/toto.txt.doc" return "/home/user")
file_get_path()
{
	file="$1"
	path=${file%%$(basename "$file")*}
	if [[ "$path" == "" ]]; then
		path="./"
	fi
	echo $path
}

# Return only name of the filename provided (eg.: "/home/user/toto.txt.doc" return "toto.txt")
file_get_name()
{
	file="$1"
	filename=$(file_get_fullname "$file")
	echo ${filename%.*}
}

# Return only extension of the filename provided (eg.: "/home/user/toto.txt.doc" return "doc")
file_get_ext()
{
	file="$1"
	filename=$(file_get_fullname "$file")
	#remove last '"'; if any
	filename=${filename%%\"*}
	if [[ $filename == *"."* ]]; then
		echo ${filename##*.}
	else
		return
	fi
}

get_caller() {
	var="$(ps | grep "$PID" | head -n 2)"
	caller=$(echo -e "${var##*/}")
	echo SCRIPT CALLED FORM \'$caller\'
	which $caller
}



gexport () {
	local pattern=$1
	eval "export | grep -i $pattern"
}

grll() {
	local pattern=$1
	local path=$2
	eval "ls -halF $path | grep -i $pattern"
}

hexdump() {
	HD=$(which hexdump)
	OPTIONS1='8/1 "%02X ""\t"" "'
	OPTIONS2='8/1 "%c""\n"'
	eval "$HD -e '$OPTIONS1' -e '$OPTIONS2' $@"
}

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
		ls -halF "$path"
	else
		ls -halF "$path" | grep --color=always "$pattern"
	fi
}

## kate() {
##     CMD="$(which kate) $(conv_path_for_win $@)"
##     echo $CMD
##     eval "$CMD"&
## }

edit() {
    CMD="npp $(conv_path_for_win $@)&"
    echo $CMD
	$CMD&
}

## make() {
##     CMD="mingw32-make $@"
 ##    echo $CMD
## 	$CMD
## }


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
    CMD="$(which notepadpp) $(conv_path_for_win $@)"
    echo $CMD
	$CMD 2>/dev/null&
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

############################################################
## Background 
############################################################

prompt_update() {
	history -a
	repoGit=$(is_git_folder)
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

	PS1_PREFIX="\D{%T}-$PREF_COLOR\h(\u):$PS1_CYAN\w\n"
	if [[ "$IAM" != "root" ]]; then
		PREF_COLOR=$GREEN
	else
		PREF_COLOR=$RED
	fi
	if [[ "$BRANCH" != "" ]]; then
		PS1_PREFIX=$PS1_PREFIX"$PS1_CYAN[$BRANCH]$PS1_ATTR_RESET"
	fi
	if [[ "$GIT_AHEAD" != "" &&  "$GIT_AHEAD" != "0" ]]; then
		PS1_PREFIX=$PS1_PREFIX"$PS1_BLUE[L:$GIT_AHEAD]$APS1_TTR_RESET"
	fi
	if [[ "$GIT_BEHIND" != "" &&  "$GIT_BEHIND" != "0" ]]; then
		PS1_PREFIX=$PS1_PREFIX"$PS1_BLUE[R:$GIT_BEHIND]$PS1_ATTR_RESET"
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

str_replace() {
	str=$1
	search=$2
	replace=$3
	result=${str//$2/$3}
	echo result=$result
	echo $result
}
export -f str_replace

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
	local who=$1
	paths=($(/bin/which -a $who) )
	echo ${paths[$((${#paths[@]} - 1))]}
}

wll() {
	local path=$(which $1)
	CMD="ls -halF --color=auto $path"; echo $CMD; $CMD
	echo $(conv_path_for_win $path)
	echo
}

export PATH=$HOME/bin/scripts:$PATH
export PATH=/usr/local/bin:$PATH

############### Completion ##########################

PS1_SVG="$PS1"

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac


# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

## if [ "$color_prompt" = yes ]; then
##     PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
## else
##     PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
## fi
ps1_prefix
PS1=$PS1_PREFIX
unset color_prompt force_color_prompt

# Whenever displaying the prompt, write the previous line to disk
export PROMPT_COMMAND=prompt_update
settitle $BASH_STR

echo Out of BASHRC_CUSTOM
