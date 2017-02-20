#!/bin/bash
RED="\e[91m"
YELLOW="\e[93m"
GREEN="\e[92m"
BLUE="\e[44m"
NO_COLOUR="\e[0m"

REMOTE=$(cat ~/.gitconfig)
REMOTE=${REMOTE##*## }
REMOTE=${REMOTE%% insteadOf*}

echo -e $YELLOW"git use remote :\n$GREEN$REMOTE$NO_COLOUR"
