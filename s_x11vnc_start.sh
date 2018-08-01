#!/bin/bash
LOGFILE="$(basename $0).log"
echo " "  >> $LOGFILE
echo "------------------------------------------------------------------------" >> $LOGFILE
echo $(date)  >> $LOGFILE
echo LOGFILE is $LOGFILE
/usr/bin/x11vnc stop
/usr/bin/x11vnc -forever -display :0 -q -bg -usepw --logappend $LOGFILE

