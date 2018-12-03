# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

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

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

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
# 
# if [ "$color_prompt" = yes ]; then
#     PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
# else
#     PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
# fi
# unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep -n --color=always'
    alias fgrep='fgrep -n --color=always'
    alias egrep='egrep -n --color=always'
fi

alias adb_trace_on="export ADB_TRACE=1"
alias adb_trace_off="unset ADB_TRACE"
# Add an "alert" alias for long running commands.  Use like so: sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias apt_autoremove="sudo apt-get autoremove"
alias apt_install="sudo apt-get install"
alias apt_remove="sudo apt-get remove"
alias apt_search="sudo apt-cache search"
alias apt_update="sudo apt-get update"
alias bdb="bashdb -x ~/.bashdbinit"
# list a bash function :
alias blist="type"
alias cddokuwikipages="cd /var/www/dokuwiki && cd data/pages"
alias cddesktop_launcher="cd /usr/share/applications"
alias df="df -h"
alias galias='alias | grep -ni'
alias getXattr="getfattr -n security.selinux "
alias ghistory='history | grep -ni'
alias glunch='lunch | grep -ni'
alias gps='ps faux | grep -ni'
alias gmount='mount | grep -ni'
alias here="cygpath.exe -w $(pwd)"
alias igrep="grep -ni"
alias immutable="sudo chattr +i "
alias l='ls -CF'
alias la='ls -A'
alias ll='ls -halF'
alias ls_attr="my_lsattr"
alias lz='sudo ls -halFZ'
alias mutable="sudo chattr -i "
## alias rm='trash'
alias rmb='$(which rm)'
alias simics='~/dev/simics/simics-4.8/simics-4.8.85/scripts/../vmxmon/scripts/install; ~/dev/simics/simics-4.8/simics-4.8.85/bin/simics'
alias simicseclipse='~/dev/simics/simics-4.8/simics-4.8.85/scripts/../vmxmon/scripts/install; ~/dev/simics/simics-4.8/simics-4.8.85/bin/simics-eclipse'
alias simicsgui='~/dev/simics/simics-4.8/simics-4.8.85/scripts/../vmxmon/scripts/install; ~/dev/simics/simics-4.8/simics-4.8.85/bin/simics-gui'
alias sudo='sudo --preserve-env'
alias sedit='gksudo kate'
alias su='su --preserve-environment'
alias tailf="tail --retry --follow=name"
alias wsyslog="echo 'cat /var/log/syslog' && cat /var/log/syslog"
alias xopen="xdg-open"
# History control
#  ignore duplicate
HISTCONTROL=ignoredups
#  size
HISTSIZE=1000

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

if [ -f /cygdrive/c/Users/fpaut/dev/scripts/git-completion.bash ]; then
	echo "git-completion.bash sourced!"
    . /cygdrive/c/Users/fpaut/dev/scripts/git-completion.bash
else
	echo "git-completion.bash not sourced..."
fi

# Personnal tools & aliases
if [ -f /cygdrive/c/Users/fpaut/dev/scripts/s_bash_tools.sh ]; then
    source /cygdrive/c/Users/fpaut/dev/scripts/s_bash_tools.sh
fi
#trap_handler_set
def_font_attributes

android_source () {
	TARGET=$1
	cdsp
	source build/envsetup.sh
	lunch $TARGET
	popd
}

android_sourced () {
	if [ "$ANDROID_BUILD_TOP" != "" ]; then
		echo "[$TARGET_PRODUCT-$TARGET_BUILD_VARIANT]"
	else
		echo "[no target]"
	fi
}

aosp() {
	if [ -z "$ANDROID_BUILD_TOP" ]; then
		echo "ANDROID_BUILD_TOP not defined, (source build/envsetup.sh && choose target (=lunch xxx))"
		return 1
	fi
	local cmd=$1
	local path=$2
	CMD="$cmd $ANDROID_BUILD_TOP/$path"
	echo; echo $CMD; echo; $CMD
}

aosp_cat() {
	if [ -z "$ANDROID_BUILD_TOP" ]; then
		echo "ANDROID_BUILD_TOP not defined, (source build/envsetup.sh && choose target (=lunch xxx))"
		return 1
	fi
	aosp cat $@
}

aosp_gedit() {
	if [ -z "$ANDROID_BUILD_TOP" ]; then
		echo "ANDROID_BUILD_TOP not defined, (source build/envsetup.sh && choose target (=lunch xxx))"
		return 1
	fi
	aosp gedit $@
}

ccache_clear() {
	CMD="ccache -C"
	echo $CMD && $CMD
}

ccache_print() {
  echo; echo "CCACHE"
  echo "USE_CCACHE=$USE_CCACHE"
  echo "CCACHE_DIR=$CCACHE_DIR"
  echo "CCACHE_SIZE=$CCACHE_SIZE"
}

ccache_set() {
#    echo "ccache_set(...)"
    USE_CCACHE=$1; # echo "USE_CCACHE=$USE_CCACHE"
    CCACHE_SIZE=$2; # echo "CCACHE_SIZE=$CCACHE_SIZE"
    CCACHE_PATH=$3; # echo "CCACHE_PATH=$CCACHE_PATH"
    if [ "$#" -gt "0" ]; then
            if [ -z $CCACHE_DIR ]; then
                    export CCACHE_DIR=$CCACHE_PATH
##		export USE_CCACHE=1
            else
                    echo "First parameter of ccache_set() undefined keep CCACHE_DIR current value : "
            fi
    else
            export CCACHE_SIZE=10G
            export CCACHE_DIR="$HOME/CCACHE"
    fi
    if [ "$USE_CCACHE" = "1" ]; then
        ccache --max-size=$CCACHE_SIZE
        ccache_print
    else
        ccache_unset
        ccache_print
    fi
}

ccache_stat_reset() {
	CMD="ccache -z"
	echo $CMD && $CMD
}

ccache_stat_show() {
	start_date=$(date)
	read -e -i "N" -p "Clear ccache statistics? ('y'es/'N'o): "
	if [[ "$REPLY" = "Y" || "$REPLY" = "y" ]]; then
		ccache_stat_reset
	fi
	watch -t -n1 "echo 'Start Date = $start_date'; echo; ccache -s"
	echo "Start date = $start_date"
	echo "End date = $(date)"
}

ccache_unset() {
  unset USE_CCACHE
  unset CCACHE_DIR
  unset CCACHE_SIZE
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
##	local unused=$(git_test_remote_modif)
}

craff() {
	local source=$@
	local file=$(basename $source)
	local filename=${file%%.*}
	local ext=${file##*.}
	local srcpath=${source%/*}
	local output="$filename.craff"
	local craffpath="~/dev/simics/simics-4.8/simics-4.8.85/bin/"
	echo "craffpath=$craffpath"; echo
	cmd="$craffpath/craff $source"; echo $cmd; eval "$cmd"
	cmd="mv $source $srcpath/$filename.uncraff.$ext"; echo $cmd; eval "$cmd"
	cmd="mv craff.out $srcpath/$filename.$ext"; echo $cmd; eval "$cmd"
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

# exit() {
# 	trap_handler_unset
# 	builtin exit $@
# }

filegrep () { # Global grep, ggrep name already exists in aosp (. build/envsetup.sh)
	local options=$1
	local pattern=$2
	local file=$3
	if [ -z $file ]; then
		file="*"
	fi
	eval "fgrep -n $options $pattern $file"
}

git_branch () {
	BRANCH=$(git_get_branch)
	if [ "$BRANCH" ]; then
		echo "[$BRANCH]"
	fi
}

get_repo_init () {
	if [ -e "repo_init.txt" ]; then
		FILENAME=$(ls -l repo_init.txt)
		FILENAME=${FILENAME##*->}
		FILENAME=${FILENAME##*repo_init-}
		FILENAME=${FILENAME%%.*}
		echo "[$FILENAME]"
	fi
}

git_get_branch () {
	BRANCH=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/[\1]/')
	BRANCH=${BRANCH:1:$((${#BRANCH} - 2))}
	echo "$BRANCH"
}

git_get_stash () {
	unset RESULT
	RESULT=$(git stash list 2> /dev/null)
	if [ "$RESULT" ]; then
		echo "("${RESULT%%:*}")"
	else
		echo
	fi
}

git_test_local_modif () {
	unset LOCAL
 	LOCAL=$(git diff --shortstat 2> /dev/null)
 	LOCAL=$LOCAL$(git diff --shortstat --cached 2> /dev/null)
 	LOCAL=${LOCAL%%, *}
 	LOCAL=${LOCAL:1}
	if [ "$LOCAL" ]; then
		echo "[$LOCAL]"
	fi
}

git_test_remote_modif () {
	unset REMOTE AHEAD BEHIND
	BRANCH=$(git_get_branch)
 	AHEAD=$(git commit --dry-run 2>/dev/null | grep ahead)
 	BEHIND=$(git commit --dry-run 2>/dev/null | grep behind)
	if [ "$AHEAD" ]; then
 		AHEAD=${AHEAD##*by }
 		AHEAD=${AHEAD%, *}
 		AHEAD=${AHEAD%. *}
		echo "[$AHEAD un-pushed]"
	fi
	if [ "$BEHIND" ]; then
 		BEHIND=${BEHIND##*by }
 		BEHIND=${BEHIND%, *}
 		BEHIND=${BEHIND%. *}
		echo "[$BEHIND un-pulled]"
	fi
## 	echo "git_test_remote_modif" $(date +%T)
}

git_show_unpushed_commit () {
	BRANCH=$(git_get_branch)
	REMOTE=$(eval "git remote show")
	F_REMOTE_BRANCH=($(eval "git remote show $REMOTE | grep ' $BRANCH '  | grep 'merge'"))
	REMOTE_BRANCH=${F_REMOTE_BRANCH[4]}
	eval "git log $REMOTE/$REMOTE_BRANCH..HEAD"
}

gexport () {
	local pattern=$1
	eval "export | grep -i $pattern"
}


gmin_source () {
	TARGET=$1
	cdgmin
	source build/envsetup.sh
	lunch $TARGET
	popd
}


grll() {
	local path=$1
	local pattern=$2
	eval "ls -halF $path | grep -i $pattern"
}

hexdump() {
	HD=$(which hexdump)
	OPTIONS1='8/1 "%02X ""\t"" "'
	OPTIONS2='8/1 "%c""\n"'
	eval "$HD -e '$OPTIONS1' -e '$OPTIONS2' $@"
}

irda_source () {
	TARGET=$1
	cdirda
	source build/envsetup.sh
	lunch $TARGET
	popd
}

kate() {
    CMD="$(which kate) $(cygpath -m $@)"
    echo $CMD&
	$CMD&
}

kerberos_init() {
	local done=$(klist | grep "$(date +%d)/$(date +%m)/$(date +%Y)" | grep -v renew)
	if [ "$done" != "" ]; then
		echo "Kerberos authentification already done!"
	else
		echo -e $RED
		kinit $USER@GER.CORP.INTEL.COM
		echo -e $ATTR_RESET
	fi
}

meld() {
    CMD="$(which meld) $(cygpath -u $@)"
    echo $CMD&
	$CMD&
}

my_lsattr() {
	FOLDER=$1
	CMD='lsattr $FOLDER | grep "\-i\-"'
	echo $CMD
	eval $CMD
}

ps1_prefix() {
	HOSTNAME=$(hostname)

	if [ "$(contains "$IAM" "$HOSTNAME")" = "1" ];
	then
		PREF_COLOR=$GREEN
	else
		PREF_COLOR=$BLUE
	fi
	if [ "$IAM" = "root" ]; then
		PREF_COLOR=$RED
	fi

	PS1_PREFIX="\D{%T}-$PREF_COLOR\h(\u):$ATTR_RESET\w"
}

ps1_print() {
	echo "PS1=$PS1"
}

ps1_set() {
	ps1_prefix
	local path=$(pwd)"/.git"
	if [[ -e $path && -e $path/index ]]; then
		IS_GIT=($(stat -t "$path/index"))
                echo "IS_GIT=$IS_GIT"
                GIT_SIZE=${IS_GIT[1]}
                GIT_SIZE=$(($GIT_SIZE / 1024))
                echo "GIT_SIZE=$GIT_SIZE"
                # Simple PS1 if git index bigger than 1Mo
                if [ $GIT_SIZE -gt 1024 ]; then
                        echo "GIT repository too big ("$GIT_SIZE"ko), simple PS1 defined"
                        PS1="$PS1_PREFIX: "
                else
##                        PROMPT_COMMAND="REPO_STAT=\$(get_repo_init)\$(git_branch); GIT_STAT=\$(git_test_local_modif)\$(git_test_remote_modif)"
                        PROMPT_COMMAND="IS_GIT=($(stat -t "$path/index"))"
#                        PS1="$PS1_PREFIX$YELLOW \$(git_branch)\n$RED\$(git_get_stash)\$(git_test_local_modif)\$(git_test_remote_modif)$ATTR_RESET$GREEN > $ATTR_RESET"
                        PS1="$PS1_PREFIX$YELLOW \$(git_branch)\n$RED\$(git_test_local_modif)\$(git_test_remote_modif)$ATTR_RESET$GREEN > $ATTR_RESET"
                fi
	else
		echo "Seems not a GIT repository..."
        PS1="$PS1_PREFIX$YELLOW\$REPO_STAT\n$RED\$GIT_STAT$ATTR_RESET$GREEN > $ATTR_RESET"
	fi

}

ps1_unset() {
  unset PS1
  ps1_prefix
  PS1="$PS1_PREFIX: "
}

rmt() {
	CONTINUE=true
	PARAMS=$@
	YES_FOR_ALL=false
	set -- $@
	while [ "$#" != "0" ] && [ "$YES_FOR_ALL" = "false" ]
	do
		PARAMETER="\\"$1
		FIRST_CHAR=${PARAMETER:1:1}
		if [ "$FIRST_CHAR" = "/" ]; then
            if [ -d "$1" ]; then
                read -e -i "N" -p "Suspicious parameter ${PARAMETER:1}, continue? ('y'es/'a'll yes/'N'o/'q'uit): "
                if [[ "$REPLY" = "N" || "$REPLY" = "n" ]]; then
                    CONTINUE=false
                    break
                fi
                if [[ "$REPLY" = "a" || "$REPLY" = "A" ]]; then
                    CONTINUE=true
                    YES_FOR_ALL=true
                    break
                fi
            fi
		fi
		shift
	done
	if [ "$CONTINUE" = "true" ]; then
		echo "trash $PARAMS"
		trash "$PARAMS"
	fi
}

# s (shortcuts) c (shortcud command) s' (shortcut name)
# s cd log
s() {
	declare -A shortcuts_array=(\
		["log"]="/var/log" \
	)
	local cmd=$1
	local shortcut=$2
	CMD="$cmd ${shortcuts_array[$shortcut]}"
	echo $CMD; $CMD
}

ssh_agent_init() {
	local ssh_agent_file="$HOME/ssh-agent-launched.sh"
	echo "Initialize ssh-agent"
	if [ ! -z $SSH_AGENT_PID ]; then
		echo "Re-using ssh-agent"
		echo "SSH_AGENT_PID=$SSH_AGENT_PID"
		echo "SSH_AUTH_SOCK=$SSH_AUTH_SOCK"
		export SSH_AGENT_PID
		export SSH_AUTH_SOCK
	else
		echo "Re-creating ssh-agent"
		killall ssh-agent 2>/dev/null
		CMD="$(ssh-agent -s)"; echo "$CMD"; eval "$CMD"
	fi
	CMD="ssh-add"; echo "$CMD"; $CMD
}

sueclipse() {
	caller 0
	ECL=$(eval "which eclipse")
	echo "Eclipse is here :"$ECL
	gksudo $ECL&
}

# w (which)  c (command) f (file, bash exec...)
# w gedit repo
w() {
	local cmd=$1
	local f=$2
	CMD="$cmd $(which $f)"
	echo $CMD; $CMD
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

wedit() {
	local path=$(cygpath.exe -w $(which $1))
	CMD="kate $path"; echo $CMD; $CMD
}

wls() {
	local path=$(which $1)
	CMD="ls -halF $path"; echo $CMD; $CMD
}

wline () {
	echo $(caller 0)
}

export PATH=$HOME/bin:/var/homeTmp/easyToReinstall/bin:$PATH
export PATH=$HOME/bin/scripts:$PATH
export PATH=/usr/local/bin:$PATH
export PATH=/usr/local/bin/scripts:$PATH

def_font_attributes
# Applying proxy?
### read -t 3 -e -i "N" -p "Applying proxy 'proxy.toto.com' or 'system proxy setttings'? ('N'o/'y'es): "
### echo
### if [[ "$REPLY" = "Y" || "$REPLY" = "y" ]]; then
### 	echo "Applying proxy 'proxy.toto.com'"
### 	source s_proxy_on.sh proxy.toto.com:911
### else
### 	echo "system proxy undefined"
### 	source s_proxy_off.sh
### fi

#Android SDK
## ANDROID_ROOT="/media/fpaut/efa097ff-ea10-47c0-8d21-7fa78b0c352e/dev/android-linux-x86_64-20131030"
#Android AOSP
## export AOSP_HOME=$ANDROID_ROOT/aosp

IAM=$(whoami)

export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64/
echo "JAVA_HOME=$JAVA_HOME"

echo "I am "$IAM
ps1_unset
HOSTNAME=$(hostname)
echo "Working on $HOSTNAME (HOSTNAME)"
case $HOSTNAME in
	fpaut-MOBL | fpaut-MOBL* | fpaut-mobl*)
		echo "case fpaut-MOBL*)"
		alias cdcts_root='pushd $HOME/dev/android/gmin/android-cts; ps1_set'
		alias cdcts_result='pushd $HOME/dev/android/gmin/android-cts/repository/results; ps1_set'
		alias cdgmin='pushd $HOME/dev/android/gmin; export REPO="$HOME/bin/repo-gmin"; ps1_set; echo "REPO=$REPO"'

		alias cdsimics_src='pushd /mnt/ssd2/fpaut/dev/gmin/src_simics; export REPO="$HOME/bin/repo-gmin"; ps1_set; echo "REPO=$REPO"'
		alias cdsimics_vt='cd ~/dev/simics/simics-4.8/simics-4.8.85'
		alias cdsimics_x86_bxt='cd ~/dev/simics/project/targets/x86-bxt'
		export PATH=/usr/lib/ccache:$PATH:~/bin/scripts/gmin_branch_mgmt
		ccache_set 1 "20G" "$HOME/dev/CCACHE"
		;;
	fpaut-Latitude-E5410)
		echo "case fpaut-Latitude-E5410)"
		ccache_set 1 "20G" "$HOME/dev/CCACHE"
		;;
	tequila)
		echo "case tequila)"
		alias cdgmin_L_r1='pushd $HOME/dev/gmin/l_lollipop/gmin-one-android/r1; export REPO="$HOME/bin/repo-gmin"; ps1_set; echo "REPO=$REPO"'
		alias cdgmin_L_r2='pushd $HOME/dev/gmin/l_lollipop/gmin-one-android/r2; export REPO="$HOME/bin/repo-gmin"; ps1_set; echo "REPO=$REPO"'
		alias cdgmin_root='pushd $HOME/dev/gmin; export REPO="$HOME/bin/repo-gmin"; ps1_set; echo "REPO=$REPO"'
		alias cdgmin_l='pushd /mnt/fpaut/dev/gmin/src; export REPO="$HOME/bin/repo-gmin"; ps1_set; echo "REPO=$REPO"'
		alias cdgmin_L_one='pushd /mnt/fpaut/dev/gmin/l_lollipop/gmin-one-android; export REPO="$HOME/bin/repo-gmin"; ps1_set; echo "REPO=$REPO"'
		alias cdkernel='pushd /mnt/fpaut/dev/gmin/kernel; export REPO="$HOME/bin/repo-gmin"; ps1_set; echo "REPO=$REPO"'
		alias cdirdasrc='pushd ~/dev/irda/src; ps1_set; echo "REPO=$REPO"'
		alias cdsimics_src='pushd /mnt/fpaut/dev/gmin/src_simics; export REPO="$HOME/bin/repo-gmin"; ps1_set; echo "REPO=$REPO"'
		alias cdsimics_vt='cd ~/dev/simics/simics-4.8/simics-4.8.85'
		alias cdsimics_x86_bxt='cd ~/dev/simics/project/targets/x86-bxt'
		export PATH=$PATH:~/bin/scripts/gmin_branch_mgmt
		ssh_agent_init
		ccache_set 1 "50G" "$HOME/CCACHE"
		kerberos_init
		;;
	*)
		echo "Unknown Hostname..."
		;;
esac
echo; echo "ALIAS :"
galias cd

export PATH="/home/user/.pyenv/bin:$PATH"
## eval "$(pyenv init -)"
## eval "$(pyenv virtualenv-init -)"


