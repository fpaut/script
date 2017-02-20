#! /bin/bash
source s_def_fonts_attributes.sh
PKG=$1
c_exec "bitbake -k $PKG"
