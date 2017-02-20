#! /bin/bash
source s_def_fonts_attributes.sh
pkgname=$1
c_exec "bitbake $pkgname -c listtasks"