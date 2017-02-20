make_folder_writable() {
	local folders=$@
	local folder
	for folder in $folders
	do
		echo "Check folder $folder"
		if [ -e $folder ]; then
			echo "make '$folder' writable"
			sudo chmod ugo+rw $folder
			sudo chown www-data:www-data $folder
		else
			echo "'$folder' doesn't exists!"
		fi
	done
}


make_folder_writable \
" conf/ \
data/ \
data/cache \
data/pages/ \
data/attic/ \
data/media \
data/media_attic/ \
data/media_meta/ \
data/meta/ \
data/locks/ \
data/index/ \
data/tmp/"
