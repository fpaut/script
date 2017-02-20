#!/bin/bash
pkg=$@
CMD="./cts-tradefed run cts --package $pkg"
echo $CMD; $CMD
