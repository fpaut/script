#! /bin/bash
FOLDER=$1
git log --name-status -10 $FOLDER
