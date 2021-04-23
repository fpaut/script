echo
echo -e $YELLOW"In .BASHRC_PERSO"$ATTR_RESET

export DEV_PATH="$HOME/dev"
export SCRIPTS_PATH="$HOME/bin/scripts"

alias cdd="cd $DEV_PATH"
alias cds="cd $SCRIPTS_PATH"
alias cdt="cd $TOOLS_PATH"
alias jenkins_CLI="java -jar jenkins-cli.jar -auth pautf:QtxS1204+ -s http://FRSOFTWARE02:8080/"



echo -e $YELLOW"Out of '.BASHRC_PERSO'"$ATTR_RESET
