echo
echo -e $YELLOW"In GIT_ALIASES"$ATTR_RESET

git config --global alias.co "checkout"
git config --global alias.unstage "reset HEAD --"
git config --global alias.last "log -1 HEAD"
git config --global alias.br "branch"
git config --global alias.ci "commit"
git config --global alias.st "status"
echo -e $YELLOW"Out of BASHRC_ALIASES"$ATTR_RESET
