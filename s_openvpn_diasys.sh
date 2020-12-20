#!/bin/bash
CMD="sudo openvpn --config \"/home/user/realHome/Documents/Doc_Perso/Boulot/Diasys/VPN_Diasys/pautf@109.205.3.142.ovpn\" --auth-user-pass \"/home/user/realHome/Documents/Doc_Perso/Boulot/Diasys/VPN_Diasys/pautf@109.205.3.142.pass\" "
echo $CMD
eval "$CMD"
## PID=$($(eval "$CMD") && echo $!)
