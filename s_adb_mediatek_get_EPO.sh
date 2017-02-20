#!/bin/bash
LOGIN=epo_alps
PASSWORD=epo_alps
serveur=epo.mediatek.com
port=21
CMD="wget ftp://$LOGIN:$PASSWORD@$serveur:$port/EPO.DAT"; echo $CMD; eval $CMD
CMD="wget ftp://$LOGIN:$PASSWORD@$serveur:$port/EPO.MD5"; echo $CMD; eval $CMD
CMD="wget ftp://$LOGIN:$PASSWORD@$serveur:$port/LEGAL.TXT"; echo $CMD; eval $CMD
CMD="adb push EPO.DAT /storage/sdcard1"; echo $CMD; eval $CMD
CMD="adb shell su -c cp /storage/sdcard1/EPO.DAT /data/misc/"; echo $CMD; eval $CMD
CMD="adb shell su -c chown gps:nvram /data/misc/EPO.DAT"; echo $CMD; eval $CMD

CMD="adb shell rm /storage/sdcard1/EPO.DAT"; echo $CMD; eval $CMD
## CMD="adb push EPO.MD5 /data/misc"; echo $CMD; eval $CMD
