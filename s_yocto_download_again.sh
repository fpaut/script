# !/bin/sh
source s_def_fonts_attributes.sh
echo "Download again the source program"
pkgname=$1
c_exec "bitbake $pkgname -c fetch -f"
