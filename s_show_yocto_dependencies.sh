#! /bin/bash
source s_def_fonts_attributes.sh
target_image=$1
c_exec "bitbake -g -u depexp $target_image"
