#! /bin/bash
email=$1
msg="./msg.txt"
patch="./patch.txt"
infomail="./info.txt"
rm $msg
rm $patch
rm $infomail
CMD="git mailinfo -k -u --scissors $msg $patch < $email > $infomail"
echo $CMD
$CMD
echo "This email contains the following patch = " $patch
echo "********************"
cat $patch
echo "********************"
echo "with the following message = " $msg
echo "********************"
cat $msg
echo "********************"
echo "and the following informations = " $infomail
echo "********************"
cat $infomail
echo "********************"

