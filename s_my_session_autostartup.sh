#! /bin/bash
notify-send "autostart program launched!"
echo "*******************************************************" >> ~/log_my_autostart.txt
echo $(date)  >> ~/log_my_autostart.txt
notify-send "xscreensaver"
xscreensaver 0>> ~/log_my_autostart.txt 1>> ~/log_my_autostart.txt 2>> ~/log_my_autostart.txt

(sleep 10 && notify-send "yakuake")&
(sleep 10 && gnome-terminal -e $(/usr/bin/yakuake)&)&

notify-send "pidgin"
$HOME/bin/scripts/pidgin.sh

