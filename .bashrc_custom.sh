echo BASHRC_CUSTOM
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
##	local unused=$(git_remote_get_modif)
}

double_backslash()
{
	str=$1
	echo $(echo $str |  sed 's,\\,/,g')
}
export -f double_backslash


git_add_alias () {
	CMD="git config --global alias.$1 $2"
	echo $CMD && $CMD
}

git_cmd () {
	rev1=$1
	rev2=$2
	if [[ "$rev1" == "" ]]; then
		echo One revision at least is needed
		exit 1
	fi
	if [[ "$rev2" == "" ]]; then
		rev2="HEAD"
	fi
	CMD="git diff $rev1 $rev2"
	echo $CMD && $CMD
}

git_diff_show_file(){
	branch=$1
	pattern=$2
	git diff "$branch" | grep diff | grep "$pattern" | while read item
	do
		file=${item##* b/}
		echo $file
	done
}

git_diff_cmp(){
	branch=$1
	pattern=$2
	git diff "$branch" | grep diff | grep "$pattern" | while read item
	do
		file=${item##* b/}
		echo file
		echo $file | hexdump
		CMD="git difftool $branch -- $file"
		echo $CMD && $CMD
	done
}

git_get_branch () {
	BRANCH=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/[\1]/')
	BRANCH=${BRANCH:1:$((${#BRANCH} - 2))}
	echo "$BRANCH"
}

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

#########################################
# Copy modified files before a pull
# (Avoiding difficult merge)
#########################################
git_dos2unix () {
	git status | grep "modified" | grep -v "\-wip" | while read file
	do
		file=${file#*:}
		CMD="dos2unix.exe $file"
		echo $CMD; $CMD
	done
	find . -iname "*"\-wip"*"
}

git_unix2dos () {
	git status | grep "modified" | grep -v "\-wip" | while read file
	do
		file=${file#*:}
		CMD="unix2dos.exe $file"
		echo $CMD; $CMD
	done
	find . -iname "*"\-wip"*"
}

git_discard () {
	file_pattern=$1
	[[ "$file_pattern" == "" ]] && echo missing file pattern to discard as first parameter &&  return 1
	if [[ "$file_pattern" == "all" ]]; then
		file_pattern=""
	fi
	git status | grep --color=never "$file_pattern" | grep ":" | grep  --color=never  -v "$WIP_PREFIX" | while read file
	do
		file=${file#*:}
		[[ "$file" != "" ]] && CMD="git checkout -- $file"
		echo $CMD; $CMD
	done
}


#########################################
# Delete file referenced by git following 
# 'pattern'
#########################################
git_rm_pattern () {
	pattern=$1
	echo "searching pattern '$pattern'"
	[[ $pattern == "" ]] && echo missing pattern as parameter &&  return 1
	echo -e $GREEN"Following file will be removed."$ATTR_RESET
	git status | grep  --color=never "$pattern" | while read file
	do
		file=${file#*:}
		CMD=" $file "
		echo $CMD
	done
	echo -e $GREEN
	read -e -i "N" -p "Ok? (y/N): "
	echo -e $ATTR_RESET
	if [[ "$REPLY" == "y" || "$REPLY" == "Y" ]]; then
		git status | grep --color=never $pattern | while read file
		do
			file=${file#*:}
			CMD="rm $file"
			echo $CMD;
			$CMD
		done
	fi
}

git_rm_pattern_check () {
	pattern=$1
	[[ $pattern == "" ]] && echo missing pattern as parameter &&  return 1
	echo -e $GREEN"Following file have this pattern $pattern."$ATTR_RESET
	git status | grep --color=never $pattern | grep  --color=never -v "$WIP_PREFIX" | while read file
	do
		echo $file
	done
}

git_get_local_modif () {
	unset LOCAL
 	LOCAL=$(git diff --shortstat 2> /dev/null)
 	LOCAL=$LOCAL$(git diff --shortstat --cached 2> /dev/null)
 	LOCAL=${LOCAL%%, *}
 	LOCAL=${LOCAL:1}
	if [ "$LOCAL" ]; then
		echo "[$LOCAL]"
	fi
}

git_remote_count_commit () {
	unset REMOTE AHEAD BEHIND
	BRANCH=$(git_get_branch)
 	AHEAD=$(git commit --dry-run 2>/dev/null | grep ahead)
 	BEHIND=$(git commit --dry-run 2>/dev/null | grep behind)
	if [ "$AHEAD" ]; then
 		AHEAD=${AHEAD##*by }
 		AHEAD=${AHEAD%, *}
 		AHEAD=${AHEAD%. *}
		echo -e $RED "[$AHEAD un-pushed]"
	fi
	if [ "$BEHIND" ]; then
 		BEHIND=${BEHIND##*by }
 		BEHIND=${BEHIND%, *}
 		BEHIND=${BEHIND%. *}
		echo -e $RED "[$BEHIND un-pulled]"
	fi
	echo -e $ATTR_RESET
## 	echo "git_get_remote_modif" $(date +%T)
}

git_remote_test_pull() {
	GITSTATUS=$(git status -uno | grep branch)
	GITSTATUS2=${GITSTATUS##*is}
	echo -e $GREEN ${GITSTATUS2##*and}
	echo -e $ATTR_RESET
}

git_remote_show_unpulled() {
	CMD="git fetch"
	echo $CMD && $CMD
	CMD="git log HEAD..origin/master --name-status"
	echo $CMD && $CMD
}
git_remote() {
	git_remote_count_commit
	echo
	git_remote_show_unpulled
	echo
	git_remote_test_pull
}

git_show_config () {
	which="$1"
	[[ "$which" == "" ]] && echo 'local' or 'global' ? && return
	if [[ "$1" == "local" ]]; then
		echo "Local git config : "
		ls -halF ./.git/config
		CMD="git config --local --list"
	else
		echo "Global git config : "
		ls -halF ~/.gitconfig
		CMD="git config --global --list"
	fi
		echo $CMD && $CMD
}

git_show_unpushed_commit () {
	BRANCH=$(git_get_branch)
	REMOTE=$(eval "git remote show")
	F_REMOTE_BRANCH=($(eval "git remote show $REMOTE | grep ' $BRANCH '  | grep 'merge'"))
	REMOTE_BRANCH=${F_REMOTE_BRANCH[4]}
	eval "git log $REMOTE/$REMOTE_BRANCH..HEAD"
}

####################################################################################################################################################################
## "WIP section" Utilities functions to manipulate Work In Progress files combined with GIT
####################################################################################################################################################################
WIP_PREFIX="WIP"

#########################################
# Show wip file, with specific pattern
#########################################
git_wip_ls () {
	export WIP_LIST
	pattern=$1
	pattern="\-$WIP_PREFIX-$pattern"
	git status | grep "$pattern" | while read file
	do
		f1=${file##*$WIP_PREFIX-}
		f1=${file%.*}
		wip=${f1##*-}
		WIP_LIST=( "$WIP_LIST" "$wip"  )
		echo WIP_LIST IN=${WIP_LIST[@]}
	done
	echo WIP_LIST OUT=${WIP_LIST[@]}
}


#########################################
# Get name of a 'wip' file
#########################################
git_wip_get_file_name () {
	file=$1
	echo  ${file%-$WIP_PREFIX*}
}

#########################################
# Get extension of a 'wip' file
#########################################
git_wip_get_file_ext () {
	file=$1
	echo ${file##*.}
}


#########################################
# Compare a backup wip file, with the 
# same "not wip" file
#########################################
git_wip_cmp () {
do_cmp=true
pattern1=$1
pattern2=$2
	git status | grep --color=never "$pattern1" | grep --color=never "\-$WIP_PREFIX" | while read file_p1
	do
		file_p1=${file_p1#*:}
		name=$(git_wip_get_file_name $file_p1)
		ext=$(git_wip_get_file_ext $file_p1)
		if [[ "$pattern2" == "" ]]; then
			# No 2nd pattern, compare with filename.ext
			file_p2=$name.$ext
		else
			# 2nd pattern exist, compare with filename-WIP-'pattern2'.ext
			file_p2=$name-$WIP_PREFIX-$pattern2.$ext
		fi
		if [ ! -f "$file_p1" ]
		then
			echo "$file_p1 does not exist"
			do_cmp=false
		fi
		if [ ! -f "$file_p2" ]
		then
			echo "$file_p2 does not exist"
			do_cmp=false
		fi
		if [[ $do_cmp ]]; then
			CMD="meld $file_p1 $file_p2&"
			echo $CMD
			$CMD
		fi
	done
}

#########################################
# Rename extension of backup wip file, by
# adding a pattern
#########################################
git_wip_rename() {
	old_pattern="$1"
	new_pattern="$2"
	if [[ old_pattern == "" || "$new_pattern" == "" ]];then
		echo "2 parameters requested (old pattern and new pattern)"
	fi
	new_pattern="$WIP_PREFIX-$new_pattern"
	git status | grep $old_pattern | grep "\-$WIP_PREFIX" | while read file
	do
		file=${file#*:}
		name=$(git_wip_get_file_name $file)
		ext=$(git_wip_get_file_ext $file)
		file1=$file
		file2=$name-$new_pattern.$ext
		CMD="mv $file $file2"
		echo $CMD; $CMD
	done
}
#########################################
# Show wip file, with specific pattern
#########################################
git_wip_restore () {
	pattern=$1
	if [[ "$pattern" != "" ]];then
		pattern="\-$WIP_PREFIX-$pattern"
	fi
	echo -e $GREEN"Following file will replace original."$ATTR_RESET
	git status | grep "$pattern" | while read file
	do
		file=${file#*:}
		name=$(git_wip_get_file_name $file)
		ext=$(git_wip_get_file_ext $file)
		CMD="copy $file -> $name.$ext"
		echo $CMD
	done
	echo -e $GREEN
	read -e -i "N" -p "Ok? (y/N): "
	echo -e $ATTR_RESET
	if [[ "$REPLY" == "y" || "$REPLY" == "Y" ]]; then
		git status | grep "$pattern" | while read file
		do
			file=${file#*:}
			name=$(git_wip_get_file_name $file)
			ext=$(git_wip_get_file_ext $file)
			CMD="cp $file $name.$ext"
			echo $CMD
			$CMD
	done
	fi
}

#########################################
# Remove wip file
#########################################
git_wip_rm () {
	pattern=$1
	if [[ "$pattern" != "" ]];then
		pattern="\-$WIP_PREFIX-$pattern"
	fi
	git_rm_pattern "$pattern"
}

#########################################
# Copy modified files before a pull
# (Avoiding difficult merge)
#########################################
git_wip_save () {
	pattern="$1"
	pattern="-$WIP_PREFIX-"$pattern
	git status | grep "modified" | while read file
	do
		file=${file#*:}
		name=${file%.*}
		ext=${file##*.}
		CMD="cp $file $name$pattern.$ext"
		echo $CMD; $CMD
	done
	find . -iname "*"-$pattern"*"
}

#########################################
# same than 'git_wip_save' but for a 
# specific revision
#########################################
git_wip_save_from_rev () {
	rev=$1
	pattern="$2"
	if [[ "$pattern" != "" ]];then
		pattern="\-$WIP_PREFIX-$pattern"
	fi
	branch=$(git branch | grep "\*")
	branch=${branch#*\*}
	git checkout $rev
	git diff-tree --no-commit-id --name-only -r $rev | while read file
	do
		name=${file%.*};
		ext=${file#*.};
		CMD="cp $file $name-$pattern.$ext"
		echo $CMD; $CMD
	done
	find . -iname "*"\-$WIP_PREFIX"*"
	git checkout $branch
	echo "Now :"
	echo "git checkout master"
	echo "meld file $name-$pattern.$ext"
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

is_git_folder() {
	repoGit=$(git rev-parse --git-dir 2>/dev/null)
	[ -d .git ] || [[ "$repoGit" != "" ]] && echo "$repoGit"
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
GITMON_FILE="$HOME/.gitmonitor"
git_monitor() {
	echo git_monitor
}

gitps1_add_remote_modif() {
	GIT_REMOTE_MODIF="[$(git_remote_get_modif)]: "
}

gitps1_remote_rm_modif() {
	unset GIT_REMOTE_MODIF
}

gitps1_update_aheadBehind() {
	isGit=$1
	unset GIT_AHEAD
	unset GIT_BEHIND
	if [[ "$isGit" ]]; then
		local_remote=$(eval git rev-list --left-right --count "$BRANCH...origin/$BRANCH 2>/dev/null")
		GIT_AHEAD=${local_remote:0:1}
		GIT_BEHIND=$(echo ${local_remote:1} | sed 's/ //g')
	fi
}

gitps1_update_branch() {
	isGit=$1
	unset BRANCH
	if [[ "$isGit" ]]; then
		BRANCH=$(cat $repoGit/HEAD)
		BRANCH=${BRANCH##*heads/}
	fi
}

gitps1_update_stash() {
	isGit=$1
	unset GIT_STASH
	unset GIT_STASH_BRANCH
	if [[ "$isGit" ]]; then
		if [[ -e "$repoGit/logs/refs/stash" ]]; then
			## 'Global' Stash (wathever the branch)
			GIT_STASH=$(cat $repoGit/logs/refs/stash | wc -l 2>/dev/null)
			## Stash specific to a branch (GIT_STASH_BRANCH)
			GIT_STASH_BRANCH=$(cat $repoGit/logs/refs/stash | grep $BRANCH | wc -l 2>/dev/null)
			if [[ "$GIT_STASH_BRANCH" == "0" ]]; then
				unset GIT_STASH_BRANCH
			fi
		fi
	fi
}


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

alias gitps1_restore=ps1_restore
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
			PS1_PREFIX=$PS1_PREFIX"$CYAN[stash]$ATTR_RESET"
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

## if [ -f /cygdrive/c/Users/fpaut/dev/scripts/git-completion.bash ]; then
## 	echo "git-completion.bash sourced!"
##     . /cygdrive/c/Users/fpaut/dev/scripts/git-completion.bash
## else
## 	echo "git-completion.bash not sourced..."
## fi

cd $HOME/dev/scripts
git config core.fileMode false
FILEMODE=$(cat .git/config | grep -i filemode)
echo -e "my scripts\t: $FILEMODE"
cd - 1>/dev/null
cd $HOME/dev/STM32_Toolchain/dt-arm-firmware
git config core.fileMode false
FILEMODE=$(cat .git/config | grep -i filemode)
echo -e "dt-arm-firmware\t: $FILEMODE"
cd - 1>/dev/null
cd $HOME/dev/STM32_Toolchain/dt-fwtools
git config core.fileMode false
FILEMODE=$(cat .git/config | grep -i filemode)
echo -e "dt-fwtools\t: $FILEMODE"
cd - 1>/dev/null
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

## export PROMPT_COMMAND+="$(echo git_get_stash)"
## export PROMPT_COMMAND+="\$(git_get_stash)"
## Customize PS1
#OK# PS1="$PS1[\$(git_get_stash]"

