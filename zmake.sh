BOARDS=$(cat Makefile | grep "BL = ")
BOARDS=${BOARDS#*= }
BOARD=$(zenity --list --column=BOARD $BOARDS)
make BOARD=$BOARD
