#!/bin/bash
CMD="users"
echo $CMD
USERS=$(eval $CMD)
for user in $USERS
do 
	ps aux | grep -v "grep" | grep -v "sshd"  | grep --color $user
done

echo -e "\n$USERS"
