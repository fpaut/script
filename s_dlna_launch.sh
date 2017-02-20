#! /bin/bash
source ~/bin/scripts/s_attributes.sh

function ERROR {
  echo "function ERROR {}"
  LOG=$@
  LOG_ERR="ERROR WITH "$LOG
  LOG_ERR_CLR=$BKG_RED"ERROR WITH "$LOG$ATTR_RESET
  
  echo -e $LOG_ERR_CLR
  echo $LOG_ERR >> $LOG_LAUNCH_FILE
}


function EXEC {
  CMD=$@
  LOG=">>>> in "$C_PATH" processing command "$CMD
  LOG_CLR=">>>> in "$ATTR_UNDERLINED$FONT_BOLD$FONT_GREEN$C_PATH$ATTR_RESET" processing command "$FONT_BOLD$BKG_BLUE$CMD$ATTR_RESET
  echo -e $LOG_CLR
  echo $LOG >> $LOG_LAUNCH_FILE
  
  SET_TERM_TITLE $LOG
  $CMD&
  if [ $? != 0 ]; then ERROR $LOG; exit; fi
}

function LAUNCH {
  TITLE=$1
  WKG_DIR=$2
  CMD=$3"  1>> "$LOG_LAUNCH_FILE" 2>> "$LOG_ERR_FILE
  NEW_CMD='nice gnome-terminal --title='$TITLE' --working-directory='$WKG_DIR' -e '$CMD
 
  echo "TITLE="$TITLE
  echo "WKG_DIR="$WKG_DIR
  echo "CMD="$CMD
  echo "NEW_CMD="$NEW_CMD
  
#  killall --quiet $CMD
  EXEC "pushd $WKG_DIR 1 > /dev/null"
  EXEC $NEW_CMD
  EXEC popd
  echo "******************************************************************************************"
}  


function INIT {
  DEF_ATTR
  C_PATH=$(pwd)
  SCRIPT_NAME=$0
  LOG_LAUNCH_FILE=$C_PATH"/s_dlna_launch.log"
  rm $LOG_LAUNCH_FILE
  LOG_ERR_FILE=$C_PATH"/s_dlna_err.log"
  rm $LOG_ERR_FILE
}



function MAIN {
  C_PATH=$(pwd)
  export C_PATH=$C_PATH"/certif/"

  EXEC "pushd certif 1 > /dev/null"
#   LAUNCH RYGEL "/rygel/src/rygel/" "/home/fpaut/bin/scripts/s_bsh_noproxy.sh;rygel"
##   sleep 1
  LAUNCH DLEYNA-SERVER-SERVICE $C_PATH"dleyna-server/server/" "./dleyna-server-service"
  LAUNCH DLEYNA-RENDER-SERVICE $C_PATH"dleyna-renderer/server/" "./dleyna-renderer-service"  
  LAUNCH CLOUDEEBUS-DLEYNA $C_PATH"cloud-dleyna/js/lib/config/" "./cloudeebus.sh"
##  LAUNCH XBMC "" "source s_bsh_noproxy.sh && xbmc"
  EXEC "sleep 2"
  EXEC "firefox file://"$C_PATH"/cloud-dleyna/index.html"
  EXEC "popd  ## return from 'certif' folder"
  EXEC "echo "$SCRIPT_NAME" FINISHED !!!!'"
}

INIT $@
MAIN

