echo "Waiting Qemu SSH server..."
ERR=1
ssh-keygen -f "/home/fpaut/.ssh/known_hosts" -R 192.168.7.2
while [ "$ERR" != "0" ]
do
  ssh -q -oStrictHostKeyChecking=no root@192.168.7.2 cloudeebus.py -d && halt
  echo "ERR=$?" > ./log_ssh.log
done
echo "Exited!"
