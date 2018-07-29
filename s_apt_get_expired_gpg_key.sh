#! /bin/bash
echo "Provide GPG Keys expired in UBUNTU"
CMD="apt-key list | grep expirée"
echo "CMD=$CMD"
eval $CMD
