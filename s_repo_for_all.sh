#! /bin/bash
set -u
CMD=$@
$REPO forall -c $CMD
