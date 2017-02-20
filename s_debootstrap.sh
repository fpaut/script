#!/bin/bash
ubuntuCodeName=$1
arch=$2
options=$3
url=$4
chrootPath=/var/chroot

if [ -z $ubuntuCodeName ]; then
    echo "parameter #1 must be the ubuntu target code name (eg.: Hardy/Gutsy/Feisty/Edgy etc.)"
    exit 1
fi

if [ -z $arch ]; then
    echo "parameter #1 must be the ubuntu target architecture (eg.: i386, amd64, powerpc etc.)"
    exit 1
fi

exec() {
    local comment=$1
    shift
    local cmd=$@
    if [ "$comment" != "" ]; then
        echo "$comment"
    fi
    if [ "$cmd" != "" ]; then
        echo "[$cmd]"
        eval "$cmd"
    fi
}
install() {
    local pkg=$1
    exec "Installing $pkg" "sudo apt-get install $pkg"
    if [ -z $(which $pkg) ]; then
        echo "This script required '$pkg'"
        exit 1
    fi
}

install debootstrap
install schroot
exec "we assume our chroot is $chrootPath" "sudo mkdir -p $chrootPath"

schroot_conf_updated=$(cat /etc/schroot/schroot.conf | grep [$ubuntuCodeName])
if [ -z $schroot_conf_updated ]; then
    exec "" "sudo cat <<EOF > /etc/schroot/schroot.conf
    [$ubuntuCodeName]
    description=Ubuntu $ubuntuCodeName
    location=$chrootPath/$ubuntuCodeName
    priority=3
    users=doko
    groups=sbuild
    root-groups=root
    EOF"
fi

if [ -z $url ]; then
    url="http://archive.ubuntu.com/ubuntu/"
fi

if [ -z $arch ]; then
    exec "Setting up your chroot with debootstrap" "sudo debootstrap $options --variant=buildd $ubuntuCodeName $chrootPath/$ubuntuCodeName $url"
else
    exec "Setting up your chroot with debootstrap" "sudo debootstrap $options --variant=buildd --arch $arch $ubuntuCodeName $chrootPath/$ubuntuCodeName $url"
fi

exec "" "sudo cp --parents /etc/resolv.conf $chrootPath/$ubuntuCodeName/"
current_dist=$(lsb_release -c)
current_dist=${current_dist##*:}
current_dist=$(echo $current_dist | sed 's/\t//g')
exec "" "sudo cp --parents /etc/apt/sources.list $chrootPath/$ubuntuCodeName/"
exec "" "sudo sed -i 's/$current_dist/$ubuntuCodeName/g' $chrootPath/$ubuntuCodeName/etc/apt/sources.list"
exec "" "sudo gedit $chrootPath/$ubuntuCodeName/etc/apt/sources.list"

exec "" "sudo chroot $chrootPath/$ubuntuCodeName"
exec "" "apt-get update"
exec "" "apt-get --no-install-recommends install wget debconf devscripts gnupg nano"  #For package-building
exec "" "apt-get update"  #clean the gpg error message
exec "" "apt-get install locales dialog"  #If you don't talk en_US
echo "Your chroot is in $chrootPath/$ubuntuCodeName"
exec "" "locale-gen en_GB.UTF-8"  # or your preferred locale
exec "" "tzselect; TZ='Continent/Country'; export TZ"  #Configure and use our local time instead of UTC; save in .profile

exec "" "exit"