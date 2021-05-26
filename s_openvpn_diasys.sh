#!/bin/bash

if [[ "$(hostname)" == "user-HP-ENVY-TS-15-Notebook-PC" ]]; then
OVPN="/home/user/realHome/Documents/Doc_Perso/Boulot/Diasys/VPN_Diasys/pautf@109.205.3.142.ovpn"
OVPN_PASS="/home/user/realHome/Documents/Doc_Perso/Boulot/Diasys/VPN_Diasys/pautf@109.205.3.142.pass"
else
OVPN="/home/user/Bureau/VPN/pautf@109.205.3.142.ovpn"
OVPN_PASS="/home/user/Bureau/VPN/pautf@109.205.3.142.pass"
fi

CMD="sudo openvpn --config $OVPN --auth-user-pass $OVPN_PASS"


echo $CMD
eval "$CMD"
## PID=$($(eval "$CMD") && echo $!)
