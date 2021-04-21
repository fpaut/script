#!/bin/bash
Distro_ISO_File=$1
arch=$2
options=$3
url=$4
if [ "$BASH" = "$0" ]; then
    sourced=true
    scriptname=${BASH_SOURCE[0]}
else   
    unset sourced
    scriptname=$0
fi

## if [ -z $sourced ]; then
##     if [ $UID -ne 0 ]; then
##         echo “This script will only work when run by “root”.”
##         exit 1
##     fi
## fi


fs_mounted=()
folder_created=()

export ro_path="/tmp/ro"
export rw_path="/tmp/rw"

contains() {
    local string=$1
    local pattern=$2
    if [[ $string == *"$pattern"* ]]
    then
        echo 1
        return 1
    else
        echo 0
        return 0
    fi
}

def_font_attributes() {
	ATTR_UNDERLINED="\e[4m"

	FONT_BOLD="\e[1m"

	BKG_RED="\e[41m"
	BKG_GREEN="\e[42m"
	BKG_BLUE="\e[44m"

	BLACK="\e[30m"
	RED="\e[91m"
	GREEN="\e[92m"
	YELLOW="\e[93m"
	BLUE="\e[34m"
	CYAN="\e[96m"
	WHITE="\e[97m"

	ATTR_RESET="\e[0m"
}


distro_chroot() {
    local dest=$1
    local cmd=$2
    my_init
    my_mount " /proc" "$dest/proc" "-o bind"
    my_mount " /dev" "$dest/dev" "-o bind"
    my_mount " /sys" "$dest/sys" "-o bind"
    my_mount " /dev/pts" "$dest/dev/pts" "-t devpts"
    if [ -d "$dest/etc/" ]; then
        exec "" "sudo cp /etc/resolv.conf $dest/etc/resolv.conf"
    fi
    exec "" "export LC_ALL=en_US.UTF-8"
    exec "" "export DISPLAY=$DISPLAY"
##    exec "" "export $(dbus-launch)"
##    exec "" "xhost +"
    exec "" "sudo chroot $dest $cmd"
    my_umount "$dest/dev/pts"
    my_umount "$dest/sys/kernel/security"
    my_umount "$dest/sys"
    my_umount "$dest/dev"
    my_umount "$dest/proc"
}

distro_cleanup() {
    txt_info "Cleanup mount points..."
    REPLY=""
    for (( idx=${#fs_mounted[@]}-1 ; idx>=0 ; idx-- )) ; do
        if [ "$REPLY" != "a" ] && [ "$REPLY" != "A" ] && [ "$REPLY" != "k" ] && [ "$REPLY" != "K" ]; then
            read -e -i "A" -p "Unmount '${fs_mounted[idx]}' ( (Y)es / (n)o / unmount (a)ll / (k)eep all )? : "
            if [ "$REPLY" == "y" ] || [ "$REPLY" == "Y" ] || [ "$REPLY" == "a" ] || [ "$REPLY" == "A" ]; then
                my_umount "${fs_mounted[idx]}"
            fi
        else
            if [ "$REPLY" != "k" ] && [ "$REPLY" != "K" ]; then
                my_umount "${fs_mounted[idx]}"
            fi
        fi
    done
    txt_info "Removing created folder..."
    REPLY=""
    for (( idx=${#folder_created[@]}-1 ; idx>=0 ; idx-- )) ; do
        if [ "$REPLY" != "a" ] && [ "$REPLY" != "A" ] && [ "$REPLY" != "k" ] && [ "$REPLY" != "K" ]; then
            read -e -i "A" -p "Delete '${folder_created[idx]}' ( (Y)es / (n)o / delete (a)ll / (k)eep all )? : "
            if [ "$REPLY" == "y" ] || [ "$REPLY" == "Y" ] || [ "$REPLY" == "a" ] || [ "$REPLY" == "A" ]; then
                my_rm "${folder_created[idx]}"
            fi
        else
            if [ "$REPLY" != "k" ] && [ "$REPLY" != "K" ]; then
                my_rm "${folder_created[idx]}"
            fi
        fi
    done
    fs_mounted=()
    folder_created=()
    export fs_mounted
    export folder_created
}

distro_create_bootconfig() {
    local dest=$1
    exec "" "sudo chmod ugo+rw $dest/syslinux/"
    exec "" "sudo echo \"
DEFAULT live
LABEL live
  menu label ^Start or install Ubuntu Remix
  kernel /casper/vmlinuz
  append  file=/cdrom/preseed/ubuntu.seed boot=casper initrd=/casper/initrd.lz root=/ --
LABEL check
  menu label ^Check CD for defects
  kernel /casper/vmlinuz
  append  boot=casper integrity-check initrd=/casper/initrd.lz quiet splash --
LABEL memtest
  menu label ^Memory test
  kernel /install/memtest
  append -
LABEL hd
  menu label ^Boot from first hard disk
  localboot 0x80
  append -
DISPLAY syslinux.txt
TIMEOUT 50
PROMPT 1 

#prompt flag_val
# 
# If flag_val is 0, display the 'boot:' prompt 
# only if the Shift or Alt key is pressed,
# or Caps Lock or Scroll lock is set (this is the default).
# If  flag_val is 1, always display the "boot:" prompt.
#  http://linux.die.net/man/1/syslinux   syslinux manpage\"  > $dest/syslinux/syslinux.cfg"
}

distro_create_cd_directory() {
    local dest=$1
    local vmlinuz_path=$2
    distro_install_pkg syslinux squashfs-tools genisoimage
    exec "Create the 3 required subdirectories" "sudo mkdir -p $dest/{casper,syslinux,install}"
    exec "Need a kernel and an initrd that was built with the Casper scripts" "sudo cp -v $vmlinuz_path/casper/vmlinuz* $dest/casper/vmlinuz"
    exec "" "sudo cp -v $vmlinuz_path/casper/initrd* $dest/casper/initrd.lz"
    exec "Need the syslinux binaries" "sudo cp -v $vmlinuz_path/isolinux/isolinux.bin $dest/syslinux/syslinux.bin"
    exec "Need the memtest binaries" "sudo cp -v $dest/boot/memtest86+.bin $dest/install/memtest"
}

distro_create_manifest() {
    local dest=$1
    exec "" "sudo chroot $dest dpkg-query -W --showformat='\${Package} \${Version}\n' | sudo tee $dest/casper/filesystem.manifest"
    exec "" "sudo cp -v $dest/casper/filesystem.manifest $dest/casper/filesystem.manifest-desktop"
    REMOVE='ubiquity ubiquity-frontend-gtk ubiquity-frontend-kde casper lupin-casper live-initramfs user-setup discover1 xresprobe os-prober libdebian-installer4'
    for i in $REMOVE ; do sudo sed -i "/${i}/d" $dest/casper/filesystem.manifest-desktop; done
}

distro_prepare_sqfs_for_mountable_iso() {
    local sqfs_path=$1
    local vmlinuz_path=$2
    distro_create_cd_directory $sqfs_path $vmlinuz_path
    distro_create_manifest $sqfs_path
    distro_create_bootconfig $sqfs_path
 }

distro_help() {
## drutrdjgdj kjyugtuy eyrsrsyre
## luylu resrsre mokkiu serrezddsr juikju /#
    echo "Export 'export DISTRO_DBG=something' for executed bash command tracing, unset DISTRO_DBG otherwise"
    
    echo "scriptname='$scriptname'"
    cat $scriptname | grep "()" | grep "distro_" | grep -v "="
    my_exit
    
    
    echo "distro_chroot 'path'"
    echo "distro_mount_iso_as_rw 'ISO_File'"
    echo "distro_mount_sqfs_as_rw 'SQFS_File'"
    echo "distro_prepare_sqfs_for_mountable_iso 'path_base' 'vmlinuz/initrd_path'"
    echo "distro_create_cd_directory 'path_base' 'vmlinuz_path' 'initrd_path'"
    echo "distro_repack_sqfs 'src' 'dest_file'"
    echo "distro_repack_iso_file 'path_base' 'dest_file' 'syslinux.bin path' 'boot.cat path' 'volume label'"
}

distro_install_pkg() {
    local pkgs=$@
    local installed
    for pkg in $pkgs; do
        installed=$(apt --installed list 1>/dev/null | grep $pkg)
        if [ "$installed" = "" ]; then
            exec "Installing $pkg" "sudo apt-get install $pkg"
        fi
        installed=$(apt --installed list | grep $pkg)
        if [ "$installed" = "" ]; then
            txt_err "This script required '$pkg'"
            my_exit 1
        fi
    done
}

distro_mount_iso_as_rw() {
    ISO_File=$1
    export ISO_File
    my_init
    iso_ro_path="$ro_path/custom-$(basename $ISO_File)"
    iso_rw_path="$rw_path/custom-$(basename $ISO_File)"
    my_mkdir "$iso_ro_path" "mount original iso file as a file system" ""
    my_mount "$ISO_File" "$iso_ro_path" "-o loop"
    my_mkdir "$iso_rw_path"
    exec "Copy iso contents into another directory (for RW access)" "sudo cp -r $iso_ro_path $rw_path"
    echo "ISO content is stored here : '$iso_rw_path'"
}

distro_mount_sqfs_as_rw() {
    my_init
    txt_info "Mount original squashfs filesystem"
    sqfs_file="$iso_ro_path/casper/filesystem.squashfs"
    sqfs_ro_path="$ro_path/custom-sqfs-$(basename $ISO_File)"
    sqfs_rw_path="$rw_path/custom-sqfs-$(basename $ISO_File)"
    my_mount "$sqfs_file" "$sqfs_ro_path" "-t squashfs -o loop"
    my_mkdir "$sqfs_rw_path"
    exec "Copy sqfs contents into another directory (for RW access)" "sudo cp -r $sqfs_ro_path $rw_path"
    echo "SQFS content is stored here : '$sqfs_rw_path'"
    
    
}

distro_repack_iso_file() {
    local src=$1
    local dest=$2
    local syslinux_bin=$3
    local boot_cat=$4
    local volume_label=$5
    exec "Recreate ISO file" \
    "sudo mkisofs -o $dest \
    -b $syslinux_bin \
    -c $boot_cat \
    -no-emul-boot \
    -joliet-long \
    -iso-level 4 \
    -boot-load-size 4 \
    -boot-info-table \
    -J \
    -R \
    -V $volume_label \
    $src"
    if [ -e last_iso.iso ]; then
        exec "" "rm last_iso.iso"
    fi
    exec "" "ln -s $dest last_iso.iso"
}

distro_repack_sqfs() {
    local src=$1
    local dest=$2
    exec "Recreate squashfs filesystem" "sudo mksquashfs $src $dest -info"
}

distro_unpack_initramfs_as_rw() {
    local initramfs_path=$1
}

exec() {
    local comment=$1
    shift
    local cmd=$@
    if [ "$comment" != "" ]; then
        txt_info "$comment"
    fi
    if [ "$cmd" != "" ]; then
        if [ ! -z $DISTRO_DBG ]; then
            txt_cmd "$cmd"
        fi
        eval "$cmd"
        ERR=$?
        if [ "$ERR" != "0" ]; then
            distro_cleanup
            txt_err "Error with [$cmd]"
            txt_err "Exiting..."
            my_exit $ERR
        fi
    fi
}

my_init() {
    if [ ! -e $ro_path ]; then
        my_mkdir "$ro_path"
    fi
    if [ ! -e $rw_path ]; then
        my_mkdir "$rw_path"
    fi
}

my_exit() {
    local ERR=$1
    if [ ! -z $sourced ]; then
        return $ERR 
    else
        exit $ERR
    fi
}

my_mkdir() {
    local dest=$1
    local comment=$2
    local options=" -p "$3
    if [ ! -e $dest ]; then
        exec "$comment" "sudo mkdir $options $dest"
        folder_created+=("$dest")
        export folder_created
    else
        txt_warn "folder '$dest' already exist..."
    fi
}

my_mount() {
    local src=$1
    local dest=$2
    local option=$3
    
    txt_info "Mounting $src on $dest (with $option)"
    if [ "$(contains $option "bind")" != "1" ] && [ "$(contains $option "-B")" != "1" ] && [ "$(contains $option "-R")" != "1" ]; then
        my_mkdir "$dest" "Create mount point $dest" 
    fi
    local already_mounted=$(mount | grep $dest)
    if [ "$already_mounted" = "" ]; then
        exec "" "sudo mount $option $src --target $dest"
    else
        txt_warn "Mount point '$dest' already exist..."
    fi
    fs_mounted+=("$dest")
    export fs_mounted
}

my_rm() {
    local src=$1
    
    if [ -d $src ]; then
        txt_info "Removing $src"
        exec "" "sudo rm -rf $src"
    else
        txt_warn "$src not created by the script, or not exist..."
    fi
}

my_umount() {
    local src=$1
    local mounted
    
    txt_info "Unmounting $src"
    local mounted=$(eval "mount | grep $src")
    if [ -z "$mounted" ]; then
        txt_warn "$src not mounted..."
    else
        exec "" "sudo umount $src"
    fi
}

txt_cmd() {
    local cmd=$@
    echo -e "$BLUE[$cmd]$ATTR_RESET"
}

txt_err() {
    local err=$@
    echo -e $RED"$err"$ATTR_RESET
}

txt_info() {
    local txt=$@
    echo -e $GREEN"$txt"$ATTR_RESET
}

txt_warn() {
    local txt=$@
    echo -e $YELLOW"$txt"$ATTR_RESET
}

main() {
    if [ ! -z $sourced ]; then
        echo "Script sourced!"
        distro_help
        return
    else
        def_font_attributes
        iso_ro_path="$ro_path/custom-$(basename $Distro_ISO_File)"
        iso_rw_path="$rw_path/custom-$(basename $Distro_ISO_File)"
        sqfs_ro_path="$iso_ro_path/casper/filesystem.squashfs"
        sqfs_rw_path="$rw_path/custom-sqfs-$(basename $Distro_ISO_File)"
        
        REPLY=""; exec "" "read -e -i "Y" -p \"Do you want command line printed (Y'es'/n'o'/'q'uit): \""
        case $REPLY in
            y|Y)
                export DISTRO_DBG=true
            ;;
            n|N)
                unset DISTRO_DBG
            ;;
            q|Q)
                distro_cleanup
                my_exit 0
            ;;
        esac
        
        distro_mount_iso_as_rw "$Distro_ISO_File"
        distro_mount_sqfs_as_rw $sqfs_ro_path
        distro_unpack_initramfs_as_rw $sqfs_ro_path
        echo "You can make your changes..." 
        echo "squashfs filesystem is stored in [$sqfs_rw_path]"
        echo "installer filesystem is stored in [$iso_rw_path]"
        REPLY=""; exec "" "read -e -i "Y" -p \"Do you want a chroot in SQFS filesystem (\"$sqfs_rw_path\") (Y'es'/n'o'/'q'uit): \""
        case $REPLY in
            y|Y)
                distro_chroot $sqfs_rw_path
            ;;
            q|Q)
                distro_cleanup
                my_exit 0
            ;;
        esac
        REPLY=""; exec "" "read -e -i "Y" -p \"Do you want an ISO file from this SQFS filesystem (\"$sqfs_rw_path\") (Y'es'/n'o'/'q'uit): \""
        case $REPLY in
            y|Y)
                distro_prepare_sqfs_for_mountable_iso "$sqfs_rw_path" "$iso_rw_path"
               dest_file="$(dirname $Distro_ISO_File)/$(basename $Distro_ISO_File)-custom-$(date '+%Y-%m-%d_%H:%M').iso"
                distro_repack_iso_file "$sqfs_rw_path" "$dest_file" "syslinux/syslinux.bin" "syslinux/boot.cat" "CUSTOM_ISO"
            ;;
            q|Q)
                distro_cleanup
                my_exit 0
            ;;
        esac
        REPLY=""; exec "" "read -e -i "Y" -p \"Do you want a chroot in ISO filesystem (\"[$iso_rw_path]\") (Y'es'/n'o'/'q'uit): \""
        case $REPLY in
            y|Y)
                distro_chroot $iso_rw_path
            ;;
            q|Q)
                distro_cleanup
                my_exit 0
            ;;
        esac
        REPLY=""; exec "" "read -e -i "Y" -p \"Do you want an ISO file from (\"$iso_rw_path\") (Y'es'/n'o'/'q'uit): \""
        case $REPLY in
            y|Y)
                distro_repack_sqfs "$sqfs_rw_path" "$iso_rw_path/casper/filesystem.squashfs"
                dest_file="$(dirname $Distro_ISO_File)/$(basename $Distro_ISO_File)-custom-$(date '+%Y-%m-%d_%H:%M').iso"
                distro_repack_iso_file "$iso_rw_path" "$dest_file" "$iso_rw_path/syslinux/syslinux.bin" "$iso_rw_path/syslinux/boot.cat" "CUSTOM_ISO"
            ;;
            q|Q)
                distro_cleanup
                my_exit 0
            ;;
        esac
        
        distro_cleanup
    fi
}

main
