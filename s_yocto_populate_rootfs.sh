# !/bin/sh
echo "Clean and build again a package"
target_image=$1
bitbake $target_image -c rootfs -f