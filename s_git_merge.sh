#! /bin/sh
REBASE_FINISHED=0
if [ false = true ]; then
	AUTOMERGE=""
	read -e -i 'Y' -p "Use auto-merge option with meld? (Y/n/q): "
	case $REPLY in
		n | N)
		;;
		y | Y)
			AUTOMERGE="--auto-merge"
		;;
		q | Q)
			exit
		;;
	esac
fi

while [ "$REBASE_FINISHED" = "0" ];
do
	FILES=$(git status | grep "both" | cut -d ':' -f2)
	echo 'FILE LIST='${FILES[*]}
	for FILE in $FILES;
	do
		echo 'meld '$FILE
		meld $FILE $AUTOMERGE
		read -e -i 'Y' -p "git add "$FILE"? (Y/n/q): "
		case $REPLY in
			n | N)
			;;
			y | Y)
				echo 'git add '$FILE
				git add $FILE
			;;
			q | Q)
				exit
			;;
		esac
	done
	read -e -i 'C' -p "git rebase --(c)ontinue or --(s)kip? --(a)bort (C/s/q): "
	case $REPLY in
		n | N)
		;;
		a | A)
			echo 'git rebase --abort'
			git rebase --abort
		;;
		c | C)
			echo 'git rebase --continue'
			git rebase --continue
			echo 'git rebase --continue return '$?
		;;
		s | S)
			echo 'git rebase --skip'
			git rebase --skip
		;;
		q | Q)
			exit
		;;
	esac
	REBASE_FINISHED=$?
done

