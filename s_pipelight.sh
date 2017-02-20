#!/bin/bash
if [ "$#" -eq "0" ]; then
	echo "parameter : 'list' : list all plugins"
	echo "parameter : 'off plugin...' : disable each listed plugin"
	echo "parameter : 'on plugin...' : enable each listed plugin"
	pipelight-plugin --list-enabled
	exit 1
else
	PARAMS=$@
fi

# Supported standard plugins
declare -a SUPP_PLUGIN_LIST=('silverlight5.1' 'silverlight5.0' 'silverlight4' 'flash' 'unity3d' 'widevine')
# Additional plugins (experimental)
declare -a EXP_PLUGIN_LIST=('shockwave' 'foxitpdf' 'grandstream' 'adobereader' 'hikvision' 'npactivex' 'roblox' 'vizzedrgr' 'viewright-caiway' 'triangleplayer' 'x64-unity3d' 'x64-flash')

contains() {
	local search=$1
	local myarray=$2
	case "${myarray[@]}" in  *$search*) echo true; return ;; esac
}

enable_puglin() {
	local plugin=$1
	if [ $(contains $plugin "${EXP_PLUGIN_LIST[@]}") ]; then
		sudo pipelight-plugin --unlock $plugin
	fi
	pipelight-plugin --accept --enable $plugin
}

foreach_plugin() {
	local cb=$1
	declare -a list=("${!2}")
	local plugin
	for plugin in ${list[@]}
	do
		CMD="$cb $plugin"
		echo -n "$CMD : "
		eval $CMD
	done
}

if [ $(contains "list" "$PARAMS") ]; then
	echo "Supported standard plugins"
	foreach_plugin echo SUPP_PLUGIN_LIST[@]
	echo
	echo "Additional plugins (experimental)"
	foreach_plugin echo EXP_PLUGIN_LIST[@]
	exit 0
fi

if [ "" ]; then
	FIREFOX=$(pidof firefox)
	if [ "$FIREFOX" != "" ]; then
		echo "please, close firefox"; EXIT=true
	fi
	EVOLUTION=$(pidof evolution)
	if [ "$EVOLUTION" != "" ]; then
		echo "please, close evolution"; EXIT=true
	fi
	if [ "$EXIT" != "" ]; then
		exit 1
	fi
fi


if [ $(contains "on" "$PARAMS") ]; then
	echo "Enabling plugins..."
	declare -a LIST=${PARAMS:3}
	if [ "$LIST" = "" ]; then
		foreach_plugin "enable_puglin" SUPP_PLUGIN_LIST[@]
		foreach_plugin "enable_puglin" EXP_PLUGIN_LIST[@]
	else
		foreach_plugin "enable_puglin" LIST[@]
	fi
	exit 0
fi
if [ $(contains "off" "$PARAMS") ]; then
	echo "Disabling plugins..."
	declare -a LIST=${PARAMS:3}
	if [ "$LIST" = "" ]; then
		foreach_plugin "pipelight-plugin --disable" SUPP_PLUGIN_LIST[@]
		foreach_plugin "pipelight-plugin --disable" EXP_PLUGIN_LIST[@]
	else
		foreach_plugin "pipelight-plugin --disable" LIST[@]
	fi
	exit 0
fi
