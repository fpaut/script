#!/bin/bash
echo "Expand a gnome xterm ready to raise commands"
pkgname=$1
bitbake $pkgname -c devshell