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
#
# Some example alias instructions
# If these are enabled they will be used instead of any instructions
# they may mask.  For example, alias rm='rm -i' will mask the rm
# application.  To override the alias instruction use a \ before, ie
# \rm will call the real rm not the alias.
#
# Interactive operation...
# alias cp='cp -i'
alias mv='mv -i'
#
# Default to human readable figure
alias df='df -h'
alias du='du -h'
#
# Misc :)
# alias less='less -r'                          # raw control characters
# alias whence='type -a'                        # where, of a sort
##alias grep='grep --color=always'                     # show differences in colour
# alias egrep='egrep --color=auto'              # show differences in colour
alias fgrep='fgrep --color=auto'              # show differences in colour
#
# Some shortcuts for different directory listings
alias ls='ls -hF --color=tty'                 # classify files in colour
alias dir='ls --color=auto --format=vertical'
# alias vdir='ls --color=auto --format=long'
alias ll='ls -l'                              # long list
# alias la='ls -A'                              # all but . and ..
# alias l='ls -CF'                              #

########### Personnal Aliases ###########
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias bdb="bashdb -x $HOME/.bashdbinit"
alias ghistory='history | grep -i'
alias glunch='lunch | grep -ni'
alias gps='ps faux | grep -ni'
alias gmount='mount | grep -ni'
alias here=conv_path_for_win"$(pwd)"
alias igrep=" grep -ni"
alias l='ls -CF'
alias la='ls -A'
alias ll='ls -halF'
alias su='su --preserve-environment'
## alias sudo='cygstart --action=runas'
alias tailf="tail --retry --follow=name"
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

double_backslash()
{
	str=$1
	echo $(echo $str |  sed 's,\\,/,g')
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

kate() {
    CMD="$(which kate) $(conv_path_for_win $@)"
    echo $CMD
	$CMD&
}

edit() {
    CMD="npp $(conv_path_for_win $@)&"
    echo $CMD
	$CMD&
}

make() {
    CMD="mingw32-make $@"
    echo $CMD
	$CMD
}


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

	PS1_PREFIX="\D{%T}-$PREF_COLOR\h(\u):$BLUE\w\n"
	if [[ "$IAM" != "root" ]]; then
		PREF_COLOR=$GREEN
	else
		PREF_COLOR=$RED
	fi
	if [[ "$BRANCH" != "" ]]; then
		PS1_PREFIX=$PS1_PREFIX"$CYAN[$BRANCH]$ATTR_RESET"
	fi
	if [[ "$GIT_AHEAD" != "" &&  "$GIT_AHEAD" != "0" ]]; then
		PS1_PREFIX=$PS1_PREFIX"$BLUE[L:$GIT_AHEAD]$ATTR_RESET"
	fi
	if [[ "$GIT_BEHIND" != "" &&  "$GIT_BEHIND" != "0" ]]; then
		PS1_PREFIX=$PS1_PREFIX"$BLUE[R:$GIT_BEHIND]$ATTR_RESET"
	fi
	## Stash specific to a branch (GIT_STASH_BRANCH)
	if [[ "$GIT_STASH" != "" ]]; then
		## 'Global' Stash (wathever the branch)
		if [[ "$GIT_STASH_BRANCH" != "" ]]; then
			PS1_PREFIX=$PS1_PREFIX"$RED[stash x $GIT_STASH_BRANCH]$ATTR_RESET"
		else
			PS1_PREFIX=$PS1_PREFIX"$BLINK[stash]$ATTR_RESET"
		fi
	fi
	PS1_PREFIX=$PS1_PREFIX"$ATTR_RESET> "
}

ps1_unset() {
  unset PS1
  ps1_prefix
  PS1="$PS1_PREFIX: "
}

replace() {
	str=$1
	search=$2
	replace=$3
	result=${str//$2/$3}
	echo result=$result
	echo $result
}

wbdb() {
	local path=$(which $1)
	shift
	CMD="bashdb -x $HOME/.bashdbinit $path $@"; echo $CMD; $CMD
}

wcat() {
	local path=$(which $1)
	CMD="cat $path"; echo $CMD; $CMD
}

wll() {
	local path=$(which $1)
	CMD="ls -halF --color=auto $path"; echo $CMD; $CMD
	echo $(conv_path_for_win $path)
	echo
}

wedit() {
	local path=$(which $1 2>/dev/null)
	if [ "$?" -eq "0" ]; then
		local path=$(conv_path_for_win $(which $1))
	else
		path=$1
	fi
	CMD="npp $path"; echo $CMD; $CMD
}

export PATH=$HOME/bin/scripts:$PATH
export PATH=/usr/local/bin:$PATH
HOSTNAME=$(hostname)
echo "User: $USER on hostname: $HOSTNAME"

case $HOSTNAME in
	WSTMONDT019*)

		;;
	fpaut-Latitude-E5410)
		;;
	*)
		echo "Unknown Hostname..."
		;;
esac


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
