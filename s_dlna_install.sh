#!/bin/sh
#usage: ./dlna-buildhead.sh
#usage: ./dlna-buildhead.sh --build
#usage: ./dlna-buildhead.sh components_list.txt
#usage: ./dlna-buildhead.sh components_list.txt --build

echo "------------------------------------------------------------------"
echo "### dLeyna-DMC UPNP CERTIFICATION script"

sudo rm -Rf certif
#sudo -k
mkdir certif
cd certif

sync_head(){
git clone $REPOSITORY$COMPONENT.git
cd $COMPONENT
#Take the HEAD
LAST_TAG="No Tag - HEAD";
LAST_TAG_COMMIT=$(git rev-parse HEAD);

cd ..
echo "------------------------------------------------------------------" >> components_list.txt
echo $COMPONENT >> components_list.txt
echo $REPOSITORY >> components_list.txt
echo $LAST_TAG >> components_list.txt
echo $LAST_TAG_COMMIT >> components_list.txt
echo "------------------------------------------------------------------" >> report_list.txt
echo - COMPONENT: $COMPONENT >> report_list.txt
echo - REPOSITORY: $REPOSITORY >> report_list.txt
echo - TAG: $LAST_TAG >> report_list.txt
echo - COMMIT ID: $LAST_TAG_COMMIT >> report_list.txt
}

sync_tag(){
git clone $REPOSITORY$COMPONENT.git
cd $COMPONENT
if [ "$TAG" = "No Tag - HEAD" ]
 then
  COMMIT=$(git rev-parse HEAD)
 else
  COMMIT=$(git rev-parse $TAG);
  git reset --hard $COMMIT;
fi

cd ..
echo "------------------------------------------------------------------" >> components_list.txt
echo $COMPONENT >> components_list.txt
echo $REPOSITORY >> components_list.txt
echo $TAG >> components_list.txt
echo $COMMIT >> components_list.txt
echo "------------------------------------------------------------------" >> report_list.txt
echo - COMPONENT: $COMPONENT >> report_list.txt
echo - REPOSITORY: $REPOSITORY >> report_list.txt
echo - TAG: $TAG >> report_list.txt
echo - COMMIT ID: $COMMIT >> report_list.txt
}

generate_components_list(){
echo "...Generating components list: list.txt"

echo "------------------------------------------------------------------
gssdp
git://git.gnome.org/
last_tag
last_commit
------------------------------------------------------------------
gupnp
git://git.gnome.org/
last_tag
last_commit
------------------------------------------------------------------
gupnp-av
git://git.gnome.org/
last_tag
last_commit
------------------------------------------------------------------
gupnp-dlna
git://git.gnome.org/
last_tag
last_commit
------------------------------------------------------------------
dleyna-core
git://github.com/01org/
last_tag
last_commit
------------------------------------------------------------------
dleyna-connector-dbus
git://github.com/01org/
last_tag
last_commit
------------------------------------------------------------------
dleyna-renderer
git://github.com/01org/
last_tag
last_commit
------------------------------------------------------------------
dleyna-server
git://github.com/01org/
last_tag
last_commit
------------------------------------------------------------------
cloud-dleyna
git://github.com/01org/
last_tag
last_commit
------------------------------------------------------------------
cloudeebus
git://github.com/01org/
last_tag
last_commit
------------------------------------------------------------------
rygel
git://git.gnome.org/
last_tag
last_commit
------------------------------------------------------------------
END" >> list.txt

COMPONENT_LIST=list.txt
AUTO_LIST="yes"
}

generate_report(){
echo ""
echo "##################################################################"
echo " GENERATE REPORT"
echo "##################################################################"
echo ""
echo "==================================================================" >> REPORT.txt;
echo "dLeyna-DMC UPNP CERTIFICATION" >> REPORT.txt;
echo "==================================================================" >> REPORT.txt;
echo "" >> REPORT.txt;
echo Generated on $(date) >> REPORT.txt;
echo "" >> REPORT.txt;
echo "==================================================================" >> REPORT.txt;
echo "::: SYSTEM" >> REPORT.txt;
echo "==================================================================" >> REPORT.txt;
echo $(lsb_release -d) >> REPORT.txt;
echo $(lsb_release -c) >> REPORT.txt;
echo $(lsb_release -i) >> REPORT.txt;
echo $(lsb_release -r) >> REPORT.txt;
echo "" >> REPORT.txt;
echo "==================================================================" >> REPORT.txt;
echo "::: WEB BROWSER" >> REPORT.txt;
echo "==================================================================" >> REPORT.txt;
echo $(chromium-browser --version) >> REPORT.txt;
echo "" >> REPORT.txt;
echo "==================================================================" >> REPORT.txt;
echo "::: PACKAGES LIST" >> REPORT.txt;
echo "==================================================================" >> REPORT.txt;
echo "gssdp-1.0 v"$(pkg-config gssdp-1.0 --modversion) >> REPORT.txt;
echo "gupnp-1.0 v"$(pkg-config gupnp-1.0 --modversion) >> REPORT.txt;
echo "gupnp-av-1.0 v"$(pkg-config gupnp-av-1.0 --modversion) >> REPORT.txt;
echo "gupnp-dlna-2.0 v"$(pkg-config gupnp-dlna-2.0 --modversion) >> REPORT.txt;
echo "dleyna-core-1.0 v"$(pkg-config dleyna-core-1.0 --modversion) >> REPORT.txt;
echo "dleyna-renderer-1.0 v"$(pkg-config dleyna-renderer-1.0 --modversion) >> REPORT.txt;
echo "dleyna-server-1.0 v"$(pkg-config dleyna-server-1.0 --modversion) >> REPORT.txt;
echo "dleyna-server-service-1.0 v"$(pkg-config dleyna-server-service-1.0 --modversion) >> REPORT.txt;
echo "dleyna-renderer-service-1.0 v"$(pkg-config dleyna-renderer-service-1.0 --modversion) >> REPORT.txt;
echo $(cloudeebus.py -v) >> REPORT.txt;
echo $(./src/rygel/rygel --version) >> REPORT.txt;
echo "" >> REPORT.txt;
echo "==================================================================" >> REPORT.txt;
echo "::: REPOSITORIES" >> REPORT.txt;
echo "==================================================================" >> REPORT.txt;
cat report_list.txt >> REPORT.txt;
echo "" >> REPORT.txt;
}

local_flags(){
echo $PWD
export LOCAL_OLDINCLUDEDIR=$PWD/install/usr
export LOCAL_PREFIX=$LOCAL_OLDINCLUDEDIR/local
export LOCAL_VALAFLAGS=--vapidir=$LOCAL_PREFIX/share/vala/vapi
export LOCAL_INCLUDE_DIR=$LOCAL_PREFIX/include
export LOCAL_LINK_DIR=$LOCAL_PREFIX/lib
export LOCAL_CFLAGS="-I$LOCAL_INCLUDE_DIR"
export LOCAL_LDFLAGS="-Wl,-rpath,$LOCAL_LINK_DIR"
export LOCAL_PKG_CONFIG_PATH=$LOCAL_LINK_DIR/pkgconfig/
export LOCAL_PKG_CONFIG_LIBDIR="$LOCAL_PREFIX"/share
export LOCAL_LD_LIBRARY_PATH=$LOCAL_LINK_DIR
export LOCAL_FLAGS="--prefix=$LOCAL_PREFIX --oldincludedir=$LOCAL_OLDINCLUDEDIR PKG_CONFIG_PATH=$LOCAL_PKG_CONFIG_PATH" LDFLAGS=$LOCAL_LDFLAGS
export XDG_DATA_DIRS=$XDG_DATA_DIRS:$LOCAL_PREFIX/share
export XDG_CONFIG_DIR=$LOCAL_PREFIX/etc
export VALAC="/usr/bin/valac-0.18"
export VAPIGEN="/usr/bin/vapigen-0.18"
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$LOCAL_PKG_CONFIG_PATH

echo "LOCAL_PKG_CONFIG_PATH="$LOCAL_PKG_CONFIG_PATH
echo "PKG_CONFIG_PATH="$PKG_CONFIG_PATH
}

build_autogen(){
echo "------------------------------------------------------------------"
echo "$PRG"
echo "------------------------------------------------------------------"
cd $PRG
./autogen.sh $LOCAL_FLAGS --enable-introspection
make
make install
cd ..
}

build_bootstrap(){
echo "------------------------------------------------------------------"
echo "$PRG"
echo "------------------------------------------------------------------"
cd $PRG
./bootstrap-configure $LOCAL_FLAGS
make
make install
cd ..
}

build_bootstrap_sudo(){
echo "------------------------------------------------------------------"
echo "$PRG"
echo "------------------------------------------------------------------"
cd $PRG
./bootstrap-configure $LOCAL_FLAGS
make
sudo make install
#sudo -k
cd ..
}

build_cloudeebus(){
echo "------------------------------------------------------------------"
echo "$PRG"
echo "------------------------------------------------------------------"
cd $PRG
sudo python setup.py install
#sudo -k
cd ..
}

build_rygel_sudo(){
echo "------------------------------------------------------------------"
echo "$PRG"
echo "------------------------------------------------------------------"
cd $PRG
./autogen.sh $LOCAL_FLAGS --disable-tracker-plugin --disable-valadoc --enable-debug --enable-playbin-plugin --enable-gst-launch-plugin
make
sudo make install
#sudo -k
cd ..
}

build(){
echo ""
echo "##################################################################"
echo " BUILD & INSTALL"
echo "##################################################################"
echo ""
echo "...Build components"
local_flags;

#gUPnP
PRG=gssdp;
build_autogen;

PRG=gupnp;
build_autogen;

PRG=gupnp-av;
build_autogen;

PRG=gupnp-dlna;
build_autogen;

#dleyna
PRG=dleyna-core;
build_bootstrap;

PRG=dleyna-connector-dbus;
build_bootstrap;

PRG=dleyna-renderer;
build_bootstrap_sudo;

PRG=dleyna-server;
build_bootstrap_sudo;

#cloud
PRG=cloudeebus;
build_cloudeebus;

Rygel
PRG=rygel
build_rygel_sudo;
}

#Main
reset;
if [ "$1" = "--build" ] || [ "$2" = "--build" ]
 then BUILD="yes";
 else BUILD="no";
fi

if [ -f "../"$1 ]
 then COMPONENT_LIST="../"$1;
fi

if [ -f "../"$2 ]
 then COMPONENT_LIST="../"$2;
fi

if [ "$COMPONENT_LIST" = "" ]
 then generate_components_list;
fi

#Process COMPONENT_LIST
echo ""
echo "##################################################################"
echo " SYNC"
echo "##################################################################"
echo ""
echo "Processing components List file:" $COMPONENT_LIST
pwd
cat $COMPONENT_LIST | (
while read SEP
do
 read COMPONENT;
 if [ "$COMPONENT" = "END" ]
  then echo "END";
 else
  read REPOSITORY;
  read TAG;
  read COMMIT;
  echo "--------------";
  echo - COMPONENT: $COMPONENT;
  echo - REPOSITORY: $REPOSITORY;
  echo - TAG: $TAG;
  echo - COMMIT: $COMMIT;

  sync_head;
 fi
done

echo "------------------------------------------------------------------" >> report_list.txt;
echo "------------------------------------------------------------------" >> components_list.txt;
echo "END" >> components_list.txt;

echo "------------------------------------------------------------------";
echo "Job finished";
);

#build
if [ "$BUILD" = "yes" ]
 then build;
fi

#report
generate_report;
cat REPORT.txt

#cleanup
rm report_list.txt
rm list.txt
pwd 