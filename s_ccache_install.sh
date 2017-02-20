#!/bin/bash
create_link() {
	local compiler=$1
	local CMD
	CMD="ln -s /usr/bin/ccache /usr/local/bin/$compiler"
	echo $CMD
	eval $CMD
}

local CMD="for compiler in cc gcc c++ g++ g{cc,++}-{3.3,3.4,4.1,4.2}; do create_link $compiler; done"
echo $CMD
eval $CMD
