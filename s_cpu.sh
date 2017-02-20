#!/bin/bash
echo "Collecting data..."
CMD="sudo lshw -c cpu"
echo $CMD; 
echo "Cpu informations : "
$CMD

