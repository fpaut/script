#!/bin/bash
source s_def_fonts_attributes.sh
echo "Finds the source code"
pkgname=$1
c_exec "bitbake -e $pkgname | grep ^S="