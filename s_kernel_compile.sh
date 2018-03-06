#!/bin/bash
KERN_VERSION=$1
CONFIGFILE=$2

shopt -s expand_aliases
CMD="none"
alias exit_on_error='err=$?; [[ "$err" != "0" ]] && echo "erreur sur la commande " $CMD && exit $err'
export err=0

if [ "$KERN_VERSION" = "" ]; then
	echo "#1 is kernel version name (--append-to-version)"
	echo "#2 is config file name (/boot/[config filename])"
	exit 1
fi

if [[ "$CONFIGFILE" != "" ]]; then
	CMD="cp /boot/$CONFIGFILE .config" && echo $CMD && $CMD; exit_on_error
	CMD="make oldconfig" && echo $CMD && $CMD; exit_on_error
	echo now, make menuconfig/xconfig
	echo and relaunch script with $0 $1
	exit 0
fi


read -e -i 'N' -p "make-kpkg clean? (y/N): "
case $REPLY in
	n | N)
	;;
	y | Y)
		CMD="make-kpkg clean"; echo $CMD; $CMD
		exit_on_error
	;;
esac


CMD="export CONCURRENCY_LEVEL=$(($(getconf _NPROCESSORS_ONLN)+1))" && echo $CMD && $CMD; exit_on_error

CMD="fakeroot make-kpkg -j $CONCURRENCY_LEVEL --initrd --append-to-version=-$KERN_VERSION kernel_image kernel_headers"; echo $CMD; $CMD
exit_on_error

CMD="make modules -j $CONCURRENCY_LEVEL"; echo $CMD; $CMD
exit_on_error

CMD="sudo make modules_install"; echo $CMD; $CMD
exit_on_error

CMD="sudo dpkg -i ../linux-{headers,image}-3.*.deb"; echo $CMD; $CMD
