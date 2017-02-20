#! /bin/bash
package=$1
cd /usr/local/lib/python2.7/dist-packages
echo "Removing "
ls -l $package*
sudo rm -vrf $package*
cd -
