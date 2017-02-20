#!/bin/bash -e

flsfile=$(realpath $1)
splitboot=$(realpath kernel/gmin-quilt-representation/bin/split_boot)

mkdir -p "$2"
cd "$2"
FlsTool -x $flsfile
cd boot
mkdir -p splitboot
cd splitboot
$splitboot ../boot.fls_ID0_CUST_LoadMap0.bin
mv stripped-ramdisk.img stripped-ramdisk.img.gz
mkdir -p ramdisk
cd ramdisk
gunzip -c ../stripped-ramdisk.img.gz | cpio -i

