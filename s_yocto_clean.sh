# /bin/bash
source s_def_fonts_attributes.sh
pkgname=$1
if [ ! $pkgname ]; then
  echo No package define! exit...
  exit
fi
RESULT=$(c_exec "bitbake -e $pkgname | grep ^S=")
echo RESULT=$RESULT
DIR=${RESULT%%\/$pkgname*}
echo DIR=$DIR
_DIR=${DIR##*S=\"}\/$pkgname
c_exec "rm -rf  $_DIR"
c_exec "rm -rf  ./tmp/deploy/rpm/i586/$pkgname*"
c_exec "bitbake -c cleansstate $pkgname"
