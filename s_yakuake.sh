#! /bin/bash
CMD="kill -9 $(pidof yakuake)"
echo $CMD
eval $CMD

CMD="/usr/bin/yakuake 2> /home/fpaut/LOG/yakuake.log"
echo $CMD
eval $CMD


