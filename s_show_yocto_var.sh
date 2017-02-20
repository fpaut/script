#! /bin/bash
source s_def_fonts_attributes.sh
c_exec "../scripts/contrib/bbvars.py -d ../documentation/ref-manual/ref-manual.xml -t ../meta/conf/documentation.conf -m ../meta $@"
