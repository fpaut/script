#!/bin/bash
# Seed value for pseudo-random number generator. If you re-run the Monkey with the same seed value, it will generate the same sequence of events
### seed=1
if [ ! -z $1 ]; then
	app="-p $1"
	echo "APP=$app"
fi

# Inserts a fixed delay between events.
if [ ! -z $2 ]; then
	throttle="--throttle $2"
	echo "delay between events, throttle=$throttle ms"
fi

# Adjust percentage of touch events. (Touch events are a down-up event in a single place on the screen.)
if [ ! -z $3 ]; then
	pcttouch="--pct-touch $3"
	echo "percentage of touch events, pct-touch=$pcttouch"
else
	pcttouch=40
fi

# Adjust percentage of touch events. (Touch events are a down-up event in a single place on the screen.)
if [ ! -z $4 ]; then
	count="$4"
	echo "count=$count"
else
	count=200
fi

CMD="adb shell monkey -s $seed $app $throttle $pcttouch --pct-motion 20 --pct-pinchzoom 10 --pct-trackball 0 --pct-syskeys 10 --pct-nav 0 --pct-majornav 10 --pct-appswitch 20 --pct-flip 0 --pct-anyevent 0 $count"
echo $CMD
eval $CMD
