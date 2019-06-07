#!/bin/bash
echo $(($(getconf _NPROCESSORS_ONLN)+1))
