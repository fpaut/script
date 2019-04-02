pattern=$1

	git status | grep "$pattern" | grep "$WIP_PREFIX" | while read file
	do
		file=${file#*:}
		name=${file%$WIP_PREFIX-*}
		ext=${file##*.}
		file2=$name.$ext
		echo "file=$file"
		echo "name=$name"
		echo "file2=$file2"
		CMD="meld $file $file2"
		echo $CMD; $CMD
	done
