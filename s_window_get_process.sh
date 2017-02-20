#! /bin/bash
echo 'Click on the window to determine process...'
PID=$(xprop  | grep "_NET_WM_PID(CARDINAL) = ")
PID=${PID##*_NET_WM_PID(CARDINAL) = }
PROCESS=$(sed 's/\x00/ /' /proc/$PID/cmdline)
echo "process pid is"
echo -e "process name is : \n${PROCESS%% *}"
echo -e "full command line is : \n$PROCESS"
