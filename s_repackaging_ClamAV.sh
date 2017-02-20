#!/bin/bash

iso=”ClamAVLiveCD2.0″
ver=”2.0″

if [ “$UID” -ne “0” ]
then
echo “This script will only work when run by “root”.”
exit 1
fi

# not everyone will have squash tools, install them if not found
if [ ! `which unsquashfs` ]
then
aptitude install squashfs-tools
fi

# not everyone will have genisoimage, install it if not found
if [ ! `which mkisofs` ]
then
aptitude install genisoimage
fi

START=$(date +%s)

mkdir iso
mount $iso.iso iso/ -o loop

cp -R iso/ image/

echo “Decompressing SquashFS…”
cp iso/casper/filesystem.squashfs ./
unsquashfs filesystem.squashfs

echo “Setting up Live CD chroot…”
cp /etc/resolv.conf squashfs-root/etc/resolv.conf

chroot squashfs-root/ mount /proc
chroot squashfs-root/ mount /sys
chroot squashfs-root/ mount -t devpts none /dev/pts

echo “Refreshing and updating ClamAV virus definitions…”
chroot squashfs-root/ freshclam

#cleanup chroot
echo “Cleaning up chroot…”
chroot squashfs-root/ rm -rf /tmp/*
chroot squashfs-root/ rm /etc/resolv.conf
chroot squashfs-root/ umount -l -f /proc
chroot squashfs-root/ umount -l -f /sys
chroot squashfs-root/ umount /dev/pts

echo “Removing old SquashFS filesystem…”
rm image/casper/filesystem.squashfs

echo “Creating new SquashFS filesystem…”
mksquashfs squashfs-root image/casper/filesystem.squashfs

echo “Finding and creating MD5 hash sums of files in image…”
cd image
find . -type f -print0 | xargs -0 md5sum > md5sum.txt

cd ..
echo “Creating new image…”
mkisofs -r -V “ClamAV Live CD $ver” -cache-inodes -J -l \
-b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot \
-boot-load-size 4 -boot-info-table -o $iso_new.iso image/

# Make sure that mkisofs succeeded before we try moving or renaming
# any images.
if [ $? != “0” ]
then
echo “mkisofs failed with error code: $?”
exit
fi

echo “Renaming new image, and moving original image to old…”
mv $iso.iso $iso_old.iso
mv $iso_new.iso $iso.iso

#cleanup working directory

echo “Cleaning up working directory…”
umount iso/

rm -rf squashfs-root
rm -rf image
rm -rf iso
rm filesystem.squashfs

echo “Getting MD5 and SHA1 sum of image…”
echo “MD5: ” > clamavlivecd.sums
md5sum $iso.iso >> clamavlivecd.sums
echo “SHA1: ” >> clamavlivecd.sums
sha1sum $iso.iso >> clamavlivecd.sums

END=$(date +%s)

echo “Done at `date`. The whole process took $(($END – $START)) seconds!”