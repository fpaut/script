CMD="runqemu qemux86&"
echo $CMD && eval $CMD

CMD_FILE="./cmd_list.sh"
rm $CMD_FILE
touch $CMD_FILE
chmod ugo+x $CMD_FILE
HOST=192.168.7.2

echo 'echo "Waiting Qemu SSH server..."' >> $CMD_FILE
echo 'ERR=1'>> $CMD_FILE
echo 'ssh-keygen -f "/home/fpaut/.ssh/known_hosts" -R '$HOST >> $CMD_FILE
echo 'while [ "$ERR" != "0" ]' >> $CMD_FILE
echo 'do' >> $CMD_FILE
echo '  ssh -q -oStrictHostKeyChecking=no root@'$HOST' cloudeebus.py -d && halt' >> $CMD_FILE
echo '  echo "ERR=$?" > ./log_ssh.log' >> $CMD_FILE
echo 'done' >> $CMD_FILE
echo 'echo "Exited!"' >> $CMD_FILE

sleep 3
gnome-terminal -x $CMD_FILE
