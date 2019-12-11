echo
echo In BASHRC_ALIASES
shopt -s expand_aliases

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
alias git='LANG=en_GB git'
alias glunch='lunch | grep -ni'
alias gps='ps faux | grep -ni'
alias gmount='mount | grep -ni'
alias here=conv_path_for_win"$(pwd)"
alias igrep=" grep -ni"
alias l='ls -CF'
alias la='ls -A'
alias ll='ls -halF'
alias rm='trash'
alias su='su --preserve-environment'
alias tailf="tail --retry --follow=name"
alias trash-restore='restore-trash'
alias xopen="xdg-open"

echo Out of BASHRC_ALIASES
