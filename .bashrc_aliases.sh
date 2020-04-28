echo
echo In BASHRC_ALIASES
shopt -s expand_aliases



define_alias()
{
    aliasName="$1"
    aliasCmd="$2"
    alias $aliasName 2>/dev/null 1>/dev/null
    if [[ "$?" != "0" ]]; then
        alias $aliasName="$aliasCmd"
    fi
    
}

# Interactive operation...
# define_alias "cp" "cp -i"
define_alias "mv" "mv -i"
#
# Default to human readable figure
define_alias "df" "df -h"
define_alias "du" "du -h"
#
# Misc :)
# define_alias "less" "less -r"                          # raw control characters
define_alias "whence" "type -a"                        # where, of a sort
##define_alias "grep" "grep --color always"                     # show differences in colour
# define_alias "egrep" "egrep --color auto"              # show differences in colour
define_alias "fgrep" "fgrep --color auto"              # show differences in colour
#
# Some shortcuts for different directory listings
define_alias "ls" "ls -hF --color tty"                 # classify files in colour
define_alias "dir" "ls --color auto --format vertical"
define_alias "vls" "ls --color auto --format long"
# define_alias "la" "ls -A"                              # all but . and ..
# define_alias "l" "ls -CF"                              #

########### Personnal Aliases ###########
define_alias "alert" "notify-send --urgency low -i dialog-information "
define_alias "bdb" "bashdb -x $HOME/.bashdbinit"
define_alias "fsize" "du -s"
define_alias "ghistory" "history | grep -i"
define_alias "git" "LANG=en_GB git"
define_alias "glunch" "lunch | grep -ni"
define_alias "gps" "echo \"PID TTY      STAT   TIME COMMAND\" && ps fax | grep -i"
define_alias "gmount" "mount | grep -ni"
define_alias "here" "conv_path_for_win \"$(pwd)\""
define_alias "igrep" " grep -ni"
define_alias "l" "ls -CF"
define_alias "la" "ls -A"
define_alias "rm" "trash"
define_alias "su" "su --preserve-environment"
define_alias "tailf" "tail --retry --follow name"
define_alias "trash-restore" "restore-trash"
define_alias "xopen" "xdg-open"
define_alias "sudo" "sudo env PATH $PATH"
echo Out of BASHRC_ALIASES