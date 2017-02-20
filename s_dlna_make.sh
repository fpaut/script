#! /bin/bash
source ~/bin/scripts/s_attributes.sh

usage()
{
  cat << EOF
usage: $0 options

This script build the dleyna chain.

OPTIONS:
   -h      Show this message
   -f      Force re-configure/autogen to be produce
   -p      prefix provided to configure script
EOF
exit
}

function PARSE_OPTIONS {
  FORCE_CFG=
  PREFIX=
  EXIT=
  while getopts "t:h:f:p:" OPTION; do
      case $OPTION in
	  h)
	      usage
	      exit 1
	      ;;
	  f)
	      FORCE_CFG=1
	      ;;
	  p)
	      PREFIX="$OPTARG"
	      ;;
	  t)
	     EXIT=exit
	     ;;
	  ?)
	      usage
	      exit
	      ;;
      esac
      echo "OPTION ("$OPTION$OPTARG")"
  done
  echo "PARSE_OPTIONS::FORCE_CFG="$FORCE_CFG
  echo "PARSE_OPTIONS::PREFIX="$PREFIX
  $EXIT
}




function ERROR {
  LOG=$@
  LOG_ERR="ERROR BUILDING "$LOG
  LOG_ERR_CLR=$BKG_RED"ERROR BUILDING "$LOG$ATTR_RESET
  
  echo -e $LOG_ERR_CLR
  echo $LOG_ERR >> $LOGFILE
}

function EXEC {
  CMD=$@
  C_PATH=$(pwd) 
  LOG=">>>> in "$C_PATH" processing command "$CMD
  LOG_CLR=">>>> in "$ATTR_UNDERLINED$FONT_BOLD$FONT_GREEN$C_PATH$ATTR_RESET" processing command "$FONT_BOLD$BKG_BLUE$CMD$ATTR_RESET
  echo -e $LOG_CLR
  echo $LOG >> $LOGFILE
  
  SET_TERM_TITLE $LOG
  $CMD
  if [ $? != 0 ]; then ERROR $LOG; exit; fi
}

function BUILD {
  PRJ=$1
  CFG_OPT=$2
  EXEC 'pushd '$PRJ' 1 > /dev/null'
  echo $CFG_OPT
  CFG_SCRIPT=""
  if [ -f ./configure ];then
    CFG_SCRIPT="./configure"
  else
    if [ -f ./autogen.sh ];then
      CFG_SCRIPT="./autogen.sh"
    fi
  fi
  echo "===================================================="
  echo "..  "$PRJ" in "$(pwd)
  echo "===================================================="
  
  if [ ! -f ./configure ];then
    echo "NO FILE CONFIGURE"
    EXEC $CFG_SCRIPT $CFG_OPT
    EXEC 'make clean'
  fi
  if [ $FORCE_CFG ];then
    echo -e $FONT_BOLD$FONT_YELLOW"AUTOGEN FORCED"$ATTR_RESET
    EXEC 'sudo make uninstall'
    EXEC 'make clean'
   EXEC $CFG_SCRIPT $CFG_OPT
  fi
   EXEC 'make -j'$MakeJobs
  EXEC 'sudo make install'
  EXEC 'sudo make install-data'
  EXEC 'popd'
} 


function INIT {
  C_PATH=$(pwd)
  SCRIPT_NAME=$0
  LOGFILE=$C_PATH"/s_dlna_make.log"
  rm $LOGFILE
  EXEC 'pushd certif 1 > /dev/null'
  PKG_LIST="gtk-doc-tools gnome-common uuid-dev libgee-0.8-dev libsoup2.4-dev"
  PKG_LIST=$PKG_LIST" libgstreamer-plugins-base1.0-dev libgupnp-dlna-2.0-dev"
  PKG_LIST=$PKG_LIST" libsqlite3-dev"
  PKG_LIST=$PKG_LIST" libgupnp-dlna-1.0-dev"
  PKG_LIST=$PKG_LIST" libgee-dev libsdl1.2-dev libsdl-net1.2-dev gupnp-vala"
  PKG_LIST=$PKG_LIST
  EXEC 'sudo apt-get install '$PKG_LIST
  echo --------------
  EXEC 'apt-cache policy '$PKG_LIST
  echo --------------
  MakeJobs=$(($(getconf _NPROCESSORS_ONLN)+1))
}

function MAIN {
  BUILD gupnp "--prefix"$PREFIX
  BUILD gupnp-av "--prefix"$PREFIX
  BUILD gupnp-dlna "--prefix"$PREFIX
  
  BUILD dleyna-core "--prefix"$PREFIX" --enable-debug"
  EXEC 'pushd dleyna-core 1 > /dev/null'
  EXEC 'sudo make install-pkgconfigDATA'
  EXEC 'popd'

  BUILD dleyna-connector-dbus "--prefix"$PREFIX
  BUILD dleyna-renderer "--prefix"$PREFIX" --enable-debug"
  BUILD dleyna-server "--prefix"$PREFIX" --enable-debug"

  echo "===================================================="
  echo "..VALAC"
  echo "===================================================="
  EXEC 'wget http://ftp.gnome.org/pub/gnome/sources/vala/0.20/vala-0.20.1.tar.xz'
  EXEC 'tar xvf vala-0.20.1.tar.xz'
  EXEC 'rm  vala-0.20.1.tar.xz'
  EXEC 'pushd vala-0.20.1 1 > /dev/null'
  EXEC './configure --prefix=/usr'
  EXEC 'make -j'$MakeJobs
  EXEC 'sudo make install'
  EXEC 'popd'
  BUILD rygel "--disable-tracker-plugin"



  echo "===================================================="
  echo "..CLOUDEEBUS"
  echo "===================================================="
  EXEC 'pushd cloudeebus 1 > /dev/null'
  EXEC 'pushd /usr/local/lib/python2.7/dist-packages 1 > /dev/null'
  EXEC 'sudo rm -vrf cloudeebus*'
  EXEC 'popd'
  EXEC 'sudo python setup.py install'
  EXEC 'popd'
  
  EXEC "popd ## return from 'certif' folder"
  EXEC "echo "$SCRIPT_NAME" FINISHED !!!!'"
}

PARSE_OPTIONS $@
INIT $@
MAIN

