#!/bin/bash
source s_def_fonts_attributes.sh
echo "Clean and build again a package"
pkgname=$1
c_exec "bitbake $pkgname -c rebuild -f"
if [ "$?" != "0" ]; then
	echo "ERREUR, trying only bitbake"
	c_exec "bitbake $pkgname"
fi