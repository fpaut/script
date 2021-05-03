#!/bin/bash
sudo ls 1>/dev/null 2>/dev/null
## CMD="sudo java -jar -Xmx512m /usr/share/OpenVisualTraceRoute/org.leo.traceroute.jar &"
CMD="sudo java -jar /usr/share/OpenVisualTraceRoute/org.leo.traceroute.jar &"
echo $CMD
eval "$CMD"
