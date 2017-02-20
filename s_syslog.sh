#!/bin/bash
CMD="tailf /var/log/syslog"
echo $CMD
eval "$CMD"
