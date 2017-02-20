# !/bin/sh
source s_def_fonts_attributes.sh
echo "Finds the image types being build"
image_target=$1
c_exec "bitbake $image_target | grep ^IMAGE_FSTYPES="