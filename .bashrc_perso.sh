echo
echo -e $YELLOW"In BASHRC_PERSO"$ATTR_RESET

DEV_PATH="$HOME/dev"
SCRIPTS_PATH="$HOME/bin/scripts"

alias cdd="cd $DEV_PATH"
alias cds="cd $SCRIPTS_PATH"
alias cdt="cd $TOOLS_PATH"
alias jenkins_CLI="java -jar jenkins-cli.jar -auth pautf:QtxS1204+ -s http://FRSOFTWARE02:8080/"

echo "Running SSH agent"
if [ -f "${SSH_ENV}" ]; then
  run_ssh_env;
  ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
    start_ssh_agent;
  }
else
  start_ssh_agent;
fi

echo -e $YELLOW"Out of BASHRC_PERSO"$ATTR_RESET
