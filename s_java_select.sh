#!/bin/bash
PARAM=$@
CMD="sudo update-alternatives --config java"; echo "$CMD"; eval $CMD
CMD="sudo update-alternatives --config javac"; echo "$CMD"; eval $CMD
CMD="sudo update-alternatives --config javadoc"; echo "$CMD"; eval $CMD
CMD="sudo update-alternatives --config jarsigner"; echo "$CMD"; eval $CMD

