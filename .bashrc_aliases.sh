echo
echo -e $YELLOW"In BASHRC_ALIASES"$ATTR_RESET

shopt -s expand_aliases



define_alias()
{
    aliasName="$1"
    aliasCmd="$2"
	
	# if alias not already exists
    alias $aliasName 1>/dev/null 2>/dev/null
    if [[ "$?" != "0" ]]; then
		# Define alias
        alias $aliasName="$aliasCmd"
    fi
}

########### Personnal Aliases ###########
define_alias "alert" "notify-send --urgency low -i dialog-information "
define_alias "bdb" "bashdb -x $HOME/.bashdbinit"
define_alias "df" "df -h"
define_alias "dir" "ls --color=auto --format vertical"
define_alias "du" "du -h"
define_alias "fgrep" "fgrep -n --color=auto"              # show differences in colour
define_alias "fsize" "du -s"
define_alias "getObjSize" "nm --print-size --size-sort --radix=d"
define_alias "gdf" "df -h | grep Sys. && df -h | grep"
define_alias "ghistory" "history | grep -i"
define_alias "git" "LANG=en_GB git"
define_alias "glunch" "lunch | grep -ni"
define_alias "gmount" "mount | grep -ni"
define_alias "gps" "echo \"PID TTY      STAT   TIME COMMAND\" && ps fax | grep -i"
define_alias "grep" "grep --color=always"                     # show differences without colour
define_alias "grepc" "grep --color=always"                     # show differences in colour
define_alias "gwps" "tasklist.exe | grep -i"                   # list Windows native process and grep
define_alias "here" "conv_path_for_win \"$(pwd)\""
define_alias "igrep" "grep -ni"
define_alias "l" "ls -CF"
define_alias "la" "ls -A"
define_alias "ls_switch" "du -a "
define_alias "lsl" "ls --color=auto --format long"
define_alias "mv" "mv -i"
define_alias "return_on_error" 'err=$?; [[ "$err" != "0" ]] && return $err'
define_alias "rm" "trash"
define_alias "su" "su --preserve-environment"
define_alias "sudo" "sudo env PATH=\"$PATH\""
define_alias "tailf" "tail --retry --follow name"
define_alias "trash-restore" "restore-trash"
define_alias "whence" "type -a"                        # where, of a sort
define_alias "wkill" "taskkill.exe /PID"                 # Kill Windows native process
define_alias "wps" "tasklist.exe"                        # list Windows native process
define_alias "xopen" "xdg-open"

echo -e $YELLOW"Out of BASHRC_ALIASES"$ATTR_RESET
