#! /bin/bash
echo "Fixing GPG Keys in UBUNTU"
NO_PUBKEY_VALUE=$1
if [ ! $NO_PUBKEY_VALUE ]; then
  echo "first parameter must be the 'NO_PUBKEY' hexadecimal value"
  exit
fi
CMD="sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys $NO_PUBKEY_VALUE"
echo "CMD=$CMD"
eval $CMD
