#! /bin/bash
#

# Subject prefix?
DEFAULT="YOCTO][meta-oe][PATCH"
read -e -i $DEFAULT -p "Subjet Prefix?: "
SUB_PREFIX=$REPLY
echo "SUB_PREFIX="$SUB_PREFIX

# Revision? (SHA1)
DEFAULT=HEAD
read -e -i $DEFAULT -p "SHA1? : "
SHA1=$REPLY
echo "SHA1="$SHA1

CMD="git format-patch -s --subject-prefix='"$SUB_PREFIX"' -1 "$SHA1
echo $CMD
eval $CMD