#!/bin/bash
source s_def_fonts_attributes.sh
echo "Finds bitbakes's working directory"
target=$1
c_exec "bitbake -e $target | grep ^WORKDIR="