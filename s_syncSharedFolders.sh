
echo "SYNC dev folder"
RSYNC_OPTS="-a -v -c --human-readable --progress --delete --chmod=ugo+rw -E -l --exclude '*.o *.a *.la *.pyc'"
rsync  $RSYNC_OPTS /media/sf_DEV/git /home/fpaut/dev

