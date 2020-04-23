#!/bin/bash
CMD="sudo java -jar -Xmx512m /usr/share/OpenVisualTraceRoute/org.leo.traceroute.jar &"
echo $CMD
eval "$CMD"
