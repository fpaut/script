#! /bin/sh
echo $(($(getconf _NPROCESSORS_ONLN)+1))
