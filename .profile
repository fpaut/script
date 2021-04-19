# To the extent possible under law, the author(s) have dedicated all 
# copyright and related and neighboring rights to this software to the 
# public domain worldwide. This software is distributed without any warranty. 
# You should have received a copy of the CC0 Public Domain Dedication along 
# with this software. 
# If not, see <http://creativecommons.org/publicdomain/zero/1.0/>. 

# base-files version 4.2-4

# ~/.profile: executed by the command interpreter for login shells.

# The latest version as installed by the Cygwin Setup program can
# always be found at /etc/defaults/etc/skel/.profile

# Modifying /etc/skel/.profile directly will prevent
# setup from updating it.

# The copy in your home directory (~/.profile) is yours, please
# feel free to customise it to create a shell
# environment to your liking.  If you feel a change
# would be benificial to all, please feel free to send
# a patch to the cygwin mailing list.

# User dependent .profile file
echo
echo -e $YELLOW"In .PROFILE"$ATTR_RESET

# Set user-defined locale
export LANG=en_US.UTF8

# This file is not read by bash(1) if ~/.bash_profile or ~/.bash_login
# exists.
#
# if running bash
if [ -n "${BASH_VERSION}" ]; then
	if [[ "$MINGW_PREFIX" != "" ]]; then
		if [ -f "/e/Tools/bin/scripts/.bashrc" ]; then
			SCRIPTS_PATH="/e/Tools/bin/scripts"
			source $SCRIPTS_PATH/.bashrc
		fi
	fi
	if [[ "$MINTTY_SHORTCUT" != "" ]]; then
		SCRIPTS_PATH="/cygdrive/e/Tools/bin/scripts"
       source $SCRIPTS_PATH/.bashrc
	fi 
	if [ -f "${HOME}/.bashrc" ]; then
		source "${HOME}/.bashrc"
	fi
fi

echo Out .PROFILE
echo -e $YELLOW"Out of .PROFILE"$ATTR_RESET
