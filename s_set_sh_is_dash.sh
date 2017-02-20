#!/bin/bash
source s_def_fonts_attributes.sh
c_exec "PATH_SH=$(which sh)"
c_exec "ls -l $PATH_SH"
c_exec "PATH_DASH=$(which dash)"
c_exec "ls -l $PATH_DASH"
c_exec "sudo rm $PATH_SH" 0
c_exec "sudo ln -s $PATH_DASH $PATH_SH" 0
c_exec "ls -l $PATH_SH" 0
