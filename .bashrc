echo In BASHRC
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


## Attempt to determine in which subsystem this terminal rub
## (Cygwin, WSL, MSYS, or real linux)
get_term_env()
{
	# Is it Cygwin
	[[ $(which cygpath.exe) ]] && echo cygwin && return 0
	[[ $(which wslpath) ]] && echo wsl && return 0
	
	return 1
}


unset ROOTDRIVE
	case $(get_term_env) in
		cygwin)
			echo CYGWIN!!!
			ROOTDRIVE="/cygdrive"
			source ~/bin/scripts/.bashrc_cygwin.sh
		;;
		wsl)
			echo WSL!!!
			ROOTDRIVE="/mnt"
			source ~/bin/scripts/.bashrc_winbash.sh
		;;
		*)
			echo "ENV is $(get_term_env)"
		;;
		
	esac
		
	source $ROOTDRIVE/t/bin/scripts/.bashrc_diasys.sh
# [ "$ROOTDRIVE" ] && source $BASHRC_STD
source $SCRIPTS_PATH/.bashrc_standard.sh

case $(get_company) in
	diasys)
		gitconfig_restore
	;;
	*)
		echo "Unknown company, or no bash specificities"
	;;
esac

echo Out of BASHRC
export LESSCHARSET=utf-8
