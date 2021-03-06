echo
export YELLOW="\e[0;93m"
export ATTR_RESET=$(tput sgr0)

SCRIPTNAME="$0";
echo -e $YELLOW"In .BASHRC"$ATTR_RESET
# To the extent possible under law, the author(s) have dedicated all 
# copyright and related and neighboring rights to this software to the 
# public domain worldwide. This software is distributed without any warranty. 
# You should have received a copy of the CC0 Public Domain Dedication along 
# with this software. 
# If not, see <http://creativecommons.org/publicdomain/zero/1.0/>. 

# base-files version 4.2-4

# ~/.bashrc: executed by bash(1) for interactive shells.

# The latest version as installed by the Cygwin Setup program can
# always be found at /etc/defaults/etc/skel/.bashrc

# Modifying /etc/skel/.bashrc directly will prevent
# setup from updating it.

# The copy in your home directory (~/.bashrc) is yours, please
# feel free to customise it to create a shell
# environment to your liking.  If you feel a change
# would be benifitial to all, please feel free to send
# a patch to the cygwin mailing list.

# User dependent .bashrc file

# If not running interactively, don't do anything
[[ "$-" != *i* ]] && return

## Attempt to determine in which subsystem this terminal run
## (Cygwin, WSL, MSYS, or real linux)
get_term_env()
{
	# Searching terminal environment
	[[ "$MINGW_PREFIX" != "" ]] && echo msys && return 0
	[[ "$MINTTY_SHORTCUT" != "" ]] && echo cygwin && return 0
	[[ $(which wslpath) ]] && echo wsl && return 0
	echo linuxBash
	
	return 0
}

check_var()
{
	var="$1"
	content=$(eval echo "$""$var")
	
	if [[ "$content" == "" ]];then
		echo -e $RED"$var not defined"$ATTR_RESET
	else
		echo -e $var"=$GREEN"$content$ATTR_RESET
	fi
}

unset ROOTDRIVE
	case $(get_term_env) in
		cygwin)
			echo CYGWIN!!!
			ROOTDRIVE="/cygdrive"
			source $SCRIPTS_PATH/.bashrc_cygwin.sh
		;;
		wsl)
			echo WSL!!!
			ROOTDRIVE="/mnt"
			source $ROOTDRIVE/e/Tools/bin/scripts/.bashrc_winbash.sh
		;;
		linuxBash)
			echo Linux Bash!!!
			ROOTDRIVE="/"
			source $HOME/bin/scripts/.bashrc_linuxbash.sh
		;;
		msys)
			echo Msys Bash!!!
			ROOTDRIVE="/"
			source $SCRIPTS_PATH/.bashrc_msys.sh
		;;
		*)
			echo "ENV is $(get_term_env)"
		;;
		
	esac
	
HOSTNAME=$(hostname)
echo "User: $USER on hostname: $HOSTNAME"
case $HOSTNAME in
	WSTMONDT019)
		echo DIASYS machine
		source $ROOTDRIVE/e/Tools/bin/scripts/.bashrc_diasys.sh
	;;
	user-HP-ENVY-TS-15-Notebook-PC | imane-Latitude-E5410)
		echo Personal machine
		SCRIPTS_PATH="/home/user/bin/scripts"
		source $HOME/bin/scripts/.bashrc_perso.sh
	;;
	*)
		echo "Unknown machine ($HOSTNAME), or no bash specificities"
	;;
esac
source $SCRIPTS_PATH/.bash_tools.sh

source $SCRIPTS_PATH/.bashrc_standard.sh

GIT=$(which git)
if [[ "$GIT" != "" ]]; then
$SCRIPTS_PATH/git-aliases.sh
fi
source $SCRIPTS_PATH/.bashrc_aliases.sh
source $SCRIPTS_PATH/.bashrc_git.sh

def_font_attributes

export PATH=$PATH:$SCRIPTS_PATH
export PATH=$PATH:$ROOTDRIVE/c/Users/fpaut/bin/Debug
export PATH=$PATH:$BIN_PATH

# Start SSH Agent
#----------------------------

SSH_ENV="$HOME/.ssh/environment"

function run_ssh_env() {
    echo "source ${SSH_ENV}"
  . "${SSH_ENV}" > /dev/null
}

function ssh_agent_start() {
  echo "Initializing new SSH agent..." >&2
  ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
  echo "succeeded" >&2
  chmod 600 "${SSH_ENV}"

  run_ssh_env;

   echo "ssh-add"
   ssh-add ~/.ssh/id_rsa;
}
export -f ssh_agent_start

function ssh_agent_show() {
	echo SSH_ENV= ${SSH_ENV}; echo 
	echo SSH_AGENT_PID= ${SSH_AGENT_PID}; echo 
	echo; ps fax | grep "ssh\-agent"
	echo; CMD="cat ${SSH_ENV}"; echo $CYAN$CMD$ATTR_RESET; $CMD
	echo
}
export -f ssh_agent_show

if [ -f "${SSH_ENV}" ]; then
  run_ssh_env;
  ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
   echo "ssh_agent_start $LINENO"
    ssh_agent_start;
  }
else
  echo "ssh_agent_start $LINENO"
  ssh_agent_start;
fi


check_var ROOTDRIVE
check_var HOME
check_var HOMEW
check_var BASH
check_var SCRIPTS_PATH
echo Windows home =$HOMEW

gitconfig_restore


echo -e $YELLOW"Out of .BASHRC"$ATTR_RESET
export LESSCHARSET=utf-8
