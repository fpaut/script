echo
echo -e $YELLOW"In '.BASHRC_GIT'"$ATTR_RESET

if [[ -e $HOME/.gitconfig.lock ]]; then
    echo "Deleting $HOME/.gitconfig.lock" >&2
    rm $HOME/.gitconfig.lock
fi

####################################################################################################################################################################
## "WIP section" Utilities functions to manipulate Work In Progress files combined with GIT
####################################################################################################################################################################
WIP_PREFIX="WIP"

get_wip_date()
{
	file="$1"
	wip_pattern=$(str_get_right_first "[" "$file")
	wip_date=$(str_get_right_first "[" "$wip_pattern")
	echo $(str_get_left_last "]" "$wip_date");
}

get_wip_pattern()
{
	file="$1"
	wip_pattern=$(str_get_right_first "[" "$file");
	echo $(str_get_left_last "]" "$wip_pattern");
}

get_wip_filename()
{
	file="$1"
	echo $(str_get_right_last " " "$file")
}

get_wip_path()
{
	file="$1"
	path=$(str_get_right_first " " "$file")
	echo $(str_get_left_first "/" "$path")
}

get_wip_rev()
{
	file="$1"
	wip_pattern=$(str_get_right_first "[" "$file")
	wip_date=$(str_get_right_first "[" "$wip_pattern")
	wip_rev=$(str_get_right_first "[" "$wip_date")
	echo $(str_get_left_last "]" "$wip_rev");
}

####################################################################################################################################################################
## "GIT 'CONFIGURATION' section (in bash command line, different from .gitconfig)
####################################################################################################################################################################
GIT_DIFFTOOL="meld"

git_add_alias () {
	CMD="git config --global alias.$1 $2"
	echo $CMD && $CMD
}

git_cmd () {
	rev1=$1
	rev2=$2
	if [[ "$rev1" == "" ]]; then
		echo One revision at least is needed
		return 1
	fi
	if [[ "$rev2" == "" ]]; then
		rev2="HEAD"
	fi
	CMD="git diff $rev1 $rev2"
	echo $CMD && $CMD
}

git_branch_delete()
{
	branch=$1
	if [[ "$branch" == "" ]]; then
		echo "First parameter is the branch name (origin/'branch name')"
		return 1
	fi
	CMD="git branch -D $branch"
	echo $CMD && $CMD
	CMD="git push origin --delete $branch"
	echo $CMD && $CMD
}

git_branch_get_info()
{
	echo -e $CYAN"Local Branchs"$ATTR_RESET
	git for-each-ref --format='date=%(committerdate)%09author=%(authorname)%09branch=%(refname)' | sort -k5n -k2M -k3n -k4n | grep --color=never heads | while read line
	do
		debug_log line=\"$line\"
		date=${line%+*}; date=${date#*=}; debug_log date=\"$date\"
		ignore=${line#*$date}; ignore=${ignore##*0}; debug_log ignore=\"$ignore\"
		author=${ignore#*=}; author=${author%branch=*}; debug_log author=\"$author\"
		branch=${ignore#*=}; branch=${ignore##*/}; debug_log branch=\"$branch\"
		echo -e "$branch \t$author\t$date"
	done
	echo 
	echo -e $CYAN"Remote Branchs"$ATTR_RESET
	git for-each-ref --format='date=%(committerdate)%09author=%(authorname)%09branch=%(refname)' | sort -k5n -k2M -k3n -k4n | grep --color=never remote | while read line
	do
		debug_log line=\"$line\"
		date=${line%+*}; date=${date#*=}; debug_log date=\"$date\"
		ignore=${line#*$date}; ignore=${ignore#*0}; debug_log ignore=\"$ignore\"
		author=${ignore#*=}; author=${author%branch=*}; debug_log author=\"$author\"
		branch=${ignore#*=}; branch=${ignore##*/}; debug_log branch=\"$branch\"
		echo -e "$branch \t$author\t$date"
	done
	echo 
	echo -e $CYAN"Tags:"$ATTR_RESET

	git for-each-ref --format='%(refname)%09%09%09%(authorname)%09%09%09%(committerdate)' | sort -k5n -k2M -k3n -k4n | grep --color=never tags | awk -F \"\t\" '{ printf "%-32s %-27s %s\n", $1, $2, $3 }'  | while read line
	do
		echo -e "$line"
	done		
}

git_branch_get_tag()
{
	CMD="git for-each-ref --format='%(committerdate)|%(authorname)%09%(refname)' | sort -k5n -k2M -k3n -k4n | grep --color=never tags | awk -F \"\t\" '{ printf \"%-32s %-27s %s\n\", \$1, \$2, \$3 }'"
	echo $CMD && eval $CMD
}

git_diff_file_only(){
	rev=$1
	git diff --name-only $rev
}

git_diff_show_file(){
	branch=$1
	pattern=$2
	git diff "$branch" | grep --color=never diff | grep --color=never "$pattern" | while read item
	do
		file=${item##* b/}
		echo $file
	done
}

git_diff_cmp(){
	branch=$1
	pattern=$2
	git diff "$branch" | grep --color=never diff | grep --color=never "$pattern" | while read item
	do
		file=${item##* b/}
		echo file
		echo $file | hexdump
		CMD="git difftool $branch -- $file"
		echo $CMD && $CMD
	done
}

git_debug_log_activity_OFF()
{
	CMD="export GIT_TRACE=0"
	echo "Disable verbose mode"
	echo -e $YELLOW$CMD$ATTR_RESET; eval "$CMD"
	CMD="export GIT_CURL_VERBOSE=0"
	echo "Disable network verbose mode"
	echo -e $YELLOW$CMD$ATTR_RESET; eval "$CMD"
}

git_debug_log_activity_ON()
{
	CMD="export GIT_TRACE=1"
	echo "Setting verbose mode"
	echo -e $YELLOW$CMD$ATTR_RESET; eval "$CMD"
	CMD="export GIT_CURL_VERBOSE=1"
	echo "Setting network verbose mode"
	echo -e $YELLOW$CMD$ATTR_RESET; eval "$CMD"
}

git_discard () {
	file_pattern=$1
	[[ "$file_pattern" == "" ]] && echo missing file pattern to discard as first parameter &&  return 1
	if [[ "$file_pattern" == "all" ]]; then
		file_pattern=""
	fi
	git status -s | grep --color=never "$file_pattern" | grep --color=never  --color=never  -v "?? " | while read file
	do
		file=${file##* }
		file=${file#*:}
		[[ "$file" != "" ]] && CMD="git -c diff.mnemonicprefix=false -c core.quotepath=false --no-optional-locks checkout -- \"$file\""
		echo $CMD; eval $CMD
	done
}


git_get_branch () {
	BRANCH=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/[\1]/')
	BRANCH=${BRANCH:1:$((${#BRANCH} - 2))}
	echo "$BRANCH"
}

get_git_folder() {
	repoGit=$(git rev-parse --git-dir 2>/dev/null)
	[ -d .git ] || [[ "$repoGit" != "" ]] && echo "$repoGit"
}
export -f get_git_folder


#########################################
# Copy modified files before a pull
# (Avoiding difficult merge)
#########################################
git_dos2unix () {
	git status -s | grep --color=never "modified" | grep --color=never -v --color=never "\-wip" | while read file
	do
		file=${file#*:}
		CMD="dos2unix.exe $file"
		echo $CMD; $CMD
	done
	find . -iname "*"\-wip"*"
}

################################################################
## Restore global ~/.git config overwritten by sourcetree
gitconfig_restore()
{
    gitconfig_src=""
    case $(hostname) in
        WSTMONDT019)
            gitconfig_src=".gitconfig_diasys"
        ;;
        user-HP-ENVY-TS-15-Notebook-PC | imane-Latitude-E5410)
            gitconfig_src=".gitconfig_linux"
        ;;
        *)
            echo "Unknown machine ($HOSTNAME), or no bash specificities"
        ;;
    esac
    if [[ "$gitconfig_src" != "" ]]; then
        CMD="cp $SCRIPTS_PATH/$gitconfig_src $HOME/.gitconfig"
        echo $CMD
        $CMD
    fi
}

git_reset () {
	file_pattern=$1
	[[ "$file_pattern" == "" ]] && echo missing file pattern to discard as first parameter &&  return 1
	if [[ "$file_pattern" == "all" ]]; then
		file_pattern=""
	fi
	echo -e $GREEN"Following file will be reseted to HEAD."$ATTR_RESET
	git status -s | grep --color=never "$file_pattern" | grep --color=never ":" | grep --color=never  --color=never  -v "$WIP_PREFIX" | while read file
	do
		file=${file#*:}
		CMD=" $file "
		echo $CMD
	done
	echo -e $GREEN
	read -e -i "N" -p "Ok? (y/N): "
	echo -e $ATTR_RESET
	if [[ "$REPLY" == "y" || "$REPLY" == "Y" ]]; then
		git status -s | grep --color=never "$file_pattern" | grep --color=never ":" | grep --color=never  --color=never  -v "$WIP_PREFIX" | while read file
		do
			file=${file#*:}
			[[ "$file" != "" ]] && CMD="git reset HEAD -- $file"
			echo $CMD; $CMD
		done
	fi
}



git_get_local_modif () {
	unset LOCAL
 	LOCAL=$(git diff --shortstat 2> /dev/null)
 	LOCAL=$LOCAL$(git diff --shortstat --cached 2> /dev/null)
 	LOCAL=${LOCAL%%, *}
 	LOCAL=${LOCAL:1}
	if [ "$LOCAL" ]; then
		echo "[$LOCAL]"
	fi
}

git_patch_create()
{
	against=$1
	[[ "$against" == "" ]] && echo "First parameter is the branch/Commit for patch creating" && return
	CMD="git format-patch $against --stdout > patch_$(date +%s).patch"; echo $CMD; eval "$CMD"
}

git_patch_apply()
{
	patch_name=$1
	[[ "$patch_name" == "" ]] && echo "First parameter is the patch name" && return
	CMD="git am $patch_name"; echo $CMD; $CMD
}

git_remote_count_commit () {
	unset REMOTE AHEAD BEHIND
	BRANCH=$(git_get_branch)
 	AHEAD=$(git commit --dry-run 2>/dev/null | grep --color=never ahead)
 	BEHIND=$(git commit --dry-run 2>/dev/null | grep --color=never behind)
	if [[ ""$AHEAD"" == "" ]]; then
		AHEAD="0"
	fi
	if [[ ""$BEHIND"" == "" ]]; then
		BEHIND="0"
	fi
	if [ "$AHEAD" ]; then
 		AHEAD=${AHEAD##*by }
 		AHEAD=${AHEAD%, *}
 		AHEAD=${AHEAD%. *}
		echo -e $RED "[$AHEAD un-pushed]"
	fi
	if [ "$BEHIND" ]; then
 		BEHIND=${BEHIND##*by }
 		BEHIND=${BEHIND%, *}
 		BEHIND=${BEHIND%. *}
		echo -e $RED "[$BEHIND un-pulled]"
	fi
	echo -e $ATTR_RESET
## 	echo "git_get_remote_modif" $(date +%T)
}

git_remote_test_pull() {
	GITSTATUS=$(git status -uno | grep --color=never branch)
	GITSTATUS2=${GITSTATUS##*is}
	echo -e $GREEN ${GITSTATUS2##*and}
	echo -e $ATTR_RESET
}

git_remote_show_unpulled() {
	CMD="git fetch"
	$CMD
	CMD="git log HEAD..origin/$BRANCH --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
	eval "$CMD"
}
git_remote() {
	git_remote_count_commit
	echo
	git_remote_show_unpulled
	echo
	git_remote_test_pull
}

git_save_files_from_rev() {
	rev=$1
	pattern=$2
	
	if [[ "$rev" == "" && "$pattern" == "" ]]; then
		echo "#1 is the revision id (mandatory)"
		echo "#2 is the pattern to use while saving files (optionnal)"
		return 1
	fi
	
	if [[ "$pattern" == "" ]]; then
		pattern="REV-$rev"
	fi
	
	 git diff-tree --no-commit-id --name-only -r $rev | while read file
	 do
		path=$(file_get_path $file)
		name=$(file_get_name $file)
		ext=$(file_get_ext $file)
		
		echo file=$file
		echo path=$path
		echo name=$name
		echo ext=$ext
		
		newFile=$path/$name\_$pattern.$ext
		echo newFile=$newFile
		
		git show $rev:$file > $newFile
	 done
}

git_save_one_file_from_rev() {
	rev=$1
	file=$2

	if [[ "$rev" == "" ]]; then
		echo "No revision provided (Parameter #1)"
	fi
	if [[ "$file" == "" ]]; then
		echo "No filename provided (Parameter #2)"
	fi
	if [[ "$rev" == "" || "$file" == "" ]]; then
		return 1
	fi
	path=$(file_get_path $file)
	name=$(file_get_name $file)
	ext=$(file_get_ext $file)
	
## 	echo "Path="$path
## 	echo "Name="$name
## 	echo "Ext="$ext
	
	output_name="$name"
	output_name+="_$rev.$ext"
## 	echo "output_name="$output_name
	CMD="git show $rev:$file > $path/$output_name"
	echo $CMD
	eval "$CMD"
}

git_show_config () {
	which="$1"
	[[ "$which" == "" ]] && echo 'local' or 'global' ? && return
	if [[ "$1" == "local" ]]; then
		echo "Local git config : "
		ls -halF ./.git/config
		CMD="git config --local --list"
	else
		echo "Global git config : "
		ls -halF ~/.gitconfig
		CMD="git config --global --list"
	fi
		echo $CMD && $CMD
}

git_show_unpushed_commit () {
	BRANCH=$(git_get_branch)
	REMOTE=$(eval "git remote show")
	F_REMOTE_BRANCH=($(eval "git remote show $REMOTE | grep --color=never ' $BRANCH '  | grep --color=never 'merge'"))
	REMOTE_BRANCH=${F_REMOTE_BRANCH[4]}
	eval "git log $REMOTE/$REMOTE_BRANCH..HEAD"
}
####################################################################################################################################################################
## "GIT STASH" section : Utilities functions to manipulate files present in git stash list
####################################################################################################################################################################
git_sh_cmp() 
{
	STASH="$1"
	DIFFTOOL="$2"
	if [[ "$@" == "0" ]]; then
		echo "#1 is the stash name 'stash@{0}'..."
		echo "#2 is optional and is the diff tool name (otherwise the difftool set in git config will be used)"
		exit 1
	fi
	git stash show $STASH | grep --color=never "|"  | while read file
	do 
		file=${file%% |*}
		if [[ "$DIFFTOOL" == "" ]]; then
			CMD="git difftool -y $STASH -- $file"
		else
			dest=$HOME/tmp/$(basename $file)
			git show $STASH:$file > $dest
			CMD="$DIFFTOOL $file $dest"
		fi
		echo $CMD
		$CMD
	done
}


git_sh_save() {
	stash=$1
	pattern=$2
	if [[ "$stash" == "" ||  "$pattern" == "" ]]; then
		echo "Parameters :"
		echo " #1 : Stash ref"
		echo " #2 : pattern for adding to save"
		return 1
	fi
	echo pattern=$pattern
	pattern=$(echo $pattern |  sed 's, ,_,g')
	echo pattern=$pattern
	LANG=en_GB git stash show $stash | grep --color=never "|" | while read file
	do 
		file=${file%% |*}; 
		file=$(echo $file |  sed 's, ,,g')
		name=${file%.*}
		ext=${file##*.}
		echo name=$name
		echo ext=$ext
		echo $file will become $name$pattern.$ext;
		 git show $stash:$file > $name$pattern.$ext
	done
}



####################################################################################################################################################################
## "GIT STATUS" section : Utilities functions to manipulate files present in git status list
####################################################################################################################################################################
git_st_add () {
	pattern="$1"
	files="$2"
	[[ "$files" == "" ]] &&	
		echo "#1 list of files to copy" &&
		echo "#2 WIP pattern for rename" &&
	return 1;
	
	if [[ "$(str_contains "WIP" "$pattern")" == "0" ]]; then
		pattern="WIP_"$pattern
	fi
	
	myDate=$(date +%y)
	myDate+=_$(date +%m)
	myDate+=_$(date +%d)
	myDate+=_$(date +%H)H
	myDate+=$(date +%M)mn
	for file in ${files}
	do
		path=$(file_get_path "$file")
		name=$(file_get_name "$file")
		ext=$(file_get_ext "$file")
		rev=$(git rev-parse --verify --short HEAD)
		if [[ "$name.$ext" != "version.c"  ]]; 
		then 	
			[[ "$ext" == "" ]] && CMD="cp -v \"$path/$name\" \"$path/[ $pattern ] [ $myDate ] [ $rev ]$name\""
			[[ "$ext" != "" ]] && CMD="cp -v \"$path/$name.$ext\" \"$path/[ $pattern ] [ $myDate ] [ $rev ] $name.$ext\""
			eval $CMD
		else
			echo Files version found. Ignoring...
		fi
	done

}

git_st_cmp () {
do_cmp=false
pattern1=$1
pattern2=$2
	git status -s | grep --color=never "$pattern1" | while read file
	do
		do_cmp=false
		debug_log file=$file
		file_p1=$(get_wip_filename "$file")
		debug_log file_p1=$file_p1
		path=$(get_wip_path "$file")
		debug_log file_p1 path=$path
		ext=$(file_get_ext "$file_p1")
		debug_log file_p1 ext=$ext
		name=$(file_get_name "$file_p1")
		debug_log file_p1 name=$name
		if [[ "$ext" != "" ]]; then
			name=$name"."
		fi
		file_p2=$path/$( str_get_right_last " " "$file_p1")
		debug_log file_p2=$file_p1
		file_p1="$path/[ $(get_wip_pattern "$file") ] [ $(get_wip_date "$file") ] [ $(get_wip_rev "$file") ] $name$ext"
		debug_log "file_p1=$file_p1"
		if [[ "$pattern2" != "" ]]; then
			file=$(git status -s | grep --color=never "$name.$ext" | grep --color=never "$pattern2")
			file_p2="$path[$pattern2] [$(get_wip_date "$file")] $name.$ext"
		debug_log "file_p2=$file_p2"
		fi
		[[ ! -f "$file_p1" ]] && echo -e $RED"$file_p1 does not exist"$ATTR_RESET;
		[[ ! -f "$file_p2" ]] && echo -e $RED"$file_p2 does not exist"$ATTR_RESET;

		## DIFF
		CMD="diff \"$file_p1\" \"$file_p2\" 1>/dev/null"
		debug_log CMD=$CMD
		eval $CMD
		case  "$?" in
			"0")
				echo -e "$GREEN IDENTICAL :$ATTR_RESET $file_p1 $BLUE versus$ATTR_RESET $file_p2"
				do_cmp=false
			;;
			"1")
				echo -e "$RED DIFFERENT :$ATTR_RESET $file_p1 $BLUE versus$ATTR_RESET $file_p2"
				do_cmp=true
			;;
			"2")
			echo -e "$RED ERROR on diff command ! (Files not found?) $ATTR_RESET"
			echo -e "$RED $CMD $ATTR_RESET"
			;;
		esac
		if [[ "$do_cmp" != "false" ]]; then		
			CMD="$GIT_DIFFTOOL \"$file_p1\" \"$file_p2\" 1>/dev/null 2>/dev/null&"
			echo $CMD; eval $CMD
		fi
	done
}

#########################################
# List _WIP names
#########################################
git_st_ls() {
	pattern=$1
	if [[ "$pattern" == "" ]]; then
		echo "If First parameter is a pattern, this function list the files names with this pattern"
		echo "otherwise the WIP names are listed"
	fi
		
	
	echo "From oldest to newest"
	if [[ "$pattern" == "" ]]; then
		LANG=en_GB git status -s | grep --color=never "WIP" | while read file; 
		do  
			echo -e "[ $(get_wip_date "$file") ]\t[ $(get_wip_rev "$file") ]\t[ $(get_wip_pattern "$file") ]"
		done | sort | uniq
	else
		LANG=en_GB git status -s | grep --color=never "$pattern" | while read file; 
		do
			echo "\"${file#*?? }\""
		done | sort
	fi
}

#########################################
# Rename extension of backup wip file, by
# adding a pattern
#########################################
git_st_rename() {
	old_pattern="$1"
	new_pattern="$2"
	[[ old_pattern == "" || "$new_pattern" == "" ]] && echo "2 parameters requested (old pattern and new pattern)"  && return 1

	# escape '[' and ']' in old_pattern
	old_pattern=$(str_replace "$old_pattern" "[" "\["); esc_old_pattern=$(str_replace "$old_pattern" "]" "\]")
	debug_log "old_pattern=$esc_old_pattern"
	git status -s | grep --color=never "$esc_old_pattern" | while read file
	do
		debug_log "FILTERED file=$file"
		file=${file#* }	## Remove 'status' provided by "git status -s"
		debug_log "STATE FILE FILTERED file=$file"
		path=$(file_get_path $file)
		debug_log "path=$path"
		name=$(file_get_name $file)
		debug_log "name=$name"
		ext=$(file_get_ext $file)
		debug_log "ext=$ext"
		# Remove pattern
		name=${name##*$old_pattern}
		# Remove first space ' '
		name=${name#* }
		file1=$file
		file2="$path$new_pattern $name.$ext"
		
		debug_log "old_pattern=$esc_old_pattern"
		debug_log "name without pattern=$name"
		debug_log "New name=$file2"

		CMD="mv -v \"$file\" \"$file2\""
		echo $CMD
		eval "$CMD"
	done
}

#########################################
# Overwrite original file with a copy
#########################################
git_st_restore () {
	pattern=$1
	if [[ "$pattern" == "" ]];then
		echo "Needs of a pattern as first parameter!"
		return 1
	fi
	echo -e $GREEN"Following file will replace original."$ATTR_RESET
	git status -s | grep --color=never "$pattern" | while read file
	do
		echo ======================================
		echo file=$file
		name=$(get_wip_filename "$file")
		ext=$(file_get_ext "$name")
		path=$(file_get_path "$name")
		name=$(file_get_name "$name")
		echo path=$path
		echo name=$name
		echo ext=$ext
		[[ "$ext" != "" ]] && name=$name"."
		destname=$(str_get_right_last "]" "$name")
		CMD="copy $path/$name$ext -> $path/$destname$ext"
		echo $CMD
	done
	echo -e $GREEN
	read -e -i "N" -p "Ok? (y/N): "
	echo -e $ATTR_RESET
	if [[ "$REPLY" == "y" || "$REPLY" == "Y" ]]; then
		git status -s | grep --color=never "$pattern" | while read file
		do
			echo ======================================
			echo file=$file
			name=$(get_wip_filename "$file")
			ext=$(file_get_ext "$name")
			path=$(file_get_path "$name")
			name=$(file_get_name "$name")
			echo path=$path
			echo name=$name
			echo ext=$ext
			[[ "$ext" != "" ]] && name=$name"."
			destname=$(str_get_right_last "]" "$name")
			CMD="cp \"$path/$name$ext\" \"$path/$destname$ext\""
			echo $CMD
			eval $CMD
		done
	fi
	echo -e $GREEN
	read -e -i "N" -p "Remove Backup ($pattern)? (y/N): "
	echo -e $ATTR_RESET
	if [[ "$REPLY" == "y" || "$REPLY" == "Y" ]]; then
		git status -s | grep --color=never "$pattern" | while read file
		do
			file=$(str_get_right_first " " "$file")
			echo file=$file
			CMD="rm \"$file\""
			echo $CMD
			eval $CMD
		done
	fi
}

#########################################
# Delete file referenced by git following 
# 'pattern'
#########################################
git_st_rm () {
	local found=false
	pattern="$1"
	exclude="$2"
	echo "searching pattern '$pattern'"
	[[ "$pattern" == "" ]] && echo -e "parameter: \n#1 is 'egrep' pattern to include \n#2 is 'egrep' pattern to exclude" &&  return 1
	echo -e $GREEN"Following file will be removed."$ATTR_RESET
	if [[ "$exclude" != "" ]]; then
		cmd_list="git status -s | egrep --color=never \"$pattern\" | egrep --color=never -v \"$exclude\""
	else
		cmd_list="git status -s | egrep --color=never \"$pattern\" "
	fi
	test=$(
	eval "$cmd_list" | while read file
	do
		file=${file#* }
		file=${file#*:}
		CMD=" $file "
		echo $CMD
		found=true
	done
	)
	echo -e "$test"
	if [[ "$test" != "" ]]; then
		echo -e $GREEN
		read -e -i "N" -p "Ok? (y/N): "
		echo -e $ATTR_RESET
		if [[ "$REPLY" == "y" || "$REPLY" == "Y" ]]; then
			eval "$cmd_list" | while read file
			do
				file=${file#* }
				file=${file#*:}
				CMD="rm -rf \"$file\"  2>&1 | grep -v unsecure"
				eval $CMD
			done
		fi
	else
		echo -e $GREEN"No file found!"$ATTR_RESET
		echo -e $GREEN"file=$file"$ATTR_RESET
	fi
}

git_st_rm_check () {
	pattern=$1
	[[ $pattern == "" ]] && echo missing pattern as parameter &&  return 1
	echo -e $GREEN"Following file contains pattern '$pattern'."$ATTR_RESET
	git status -s | grep --color=never $pattern | grep --color=never -v "$WIP_PREFIX" | while read file
	do
		echo $file
	done
}

#########################################
# Copy modified files before a pull
# (Avoiding difficult merge)
#########################################
git_st_save () {
	pattern="$1"
	pattern=$(echo $pattern |  sed 's, ,_,g')
	# Remove previous saved pattern 
	echo -e $CYAN Removing previous saved pattern
	CMD="yes y | git_st_rm $pattern"; eval "$CMD"
	echo -e $ATTR_RESET
	echo
	myDate=$(date +%y)
	myDate+=_$(date +%m)
	myDate+=_$(date +%d)
	myDate+=_$(date +%H)H
	myDate+=$(date +%M)mn
	git status -s | grep --color=never -v "??" | egrep "A |M " | while read file
	do
		file=${file#* }
		file=${file#*:}
		#remove last '"'; if any
		file=${file%\"*}
		file=${file#*\"}
		git_st_add "$pattern" "$file"
	done

	find . -iname "*"-$pattern"*"
	echo -e $GREEN
	read -e -i "N" -p "Do you want to discard modified file? (y/N): "
	echo -e $ATTR_RESET
	if [[ "$REPLY" == "y" || "$REPLY" == "Y" ]]; then
		git_discard all
	fi
}

#########################################
# same than 'git_wip_save' but for a 
# specific revision
#########################################
git_st_save_from_rev () {
	rev=$1
	pattern="$2"
	if [[ "$pattern" == "" ]];then
		pattern="$rev"
		echo "PATTERN=rev"
		echo "Rev=$rev"
	fi
	echo "PATTERN="$pattern
	branch=$(git branch | grep --color=never "\*")
	branch=${branch#*\*}
	git show --pretty="" --name-only $rev | while read file
	do
		name=${file%.*};
		ext=${file#*.};
		CMD="git show $rev:$file > $name-$pattern.$ext"
		echo $CMD; eval "$CMD"
	done
	ls -halF | grep --color=never $pattern
}

#########################################
# Execute parameterized command on file
# found with "git status" command, 
# filtered with parameter 'pattern'
#########################################
git_st_exe () {
	pattern="$1"
	cmd="$2"
	if [[ "$pattern" == "" || "$cmd" == "" ]]; then
		echo "'pattern' must be the 1st parameter (and could be combined with logical operand. Eg.:"\.c|\.h""
		echo "'command' must be the 2nd parameter"
		return 1
	fi
	echo "searching pattern '$pattern'"
	echo -e $GREEN"Found following files :"$ATTR_RESET
	git status -s | egrep  --color=never "$pattern" | while read file
	do
		file=${file##* }
		file=${file#*:}
		CMD=" $file "
		echo $CMD
	done
	echo -e $GREEN
	read -e -i "N" -p "Execute '$cmd', Ok? (y/N): "
	echo -e $ATTR_RESET
	if [[ "$REPLY" == "y" || "$REPLY" == "Y" ]]; then
		git status -s | egrep --color=never "$pattern" | while read file
		do
			file=${file##* }
			file=${file#*:}
			CMD="$cmd \"$file\""
			echo "$CMD"
			eval "$CMD"
		done
	fi
}


#########################################
# git_unix2dos
#########################################
git_unix2dos () {
	git status -s | grep --color=never "modified" | grep --color=never -v "\-wip" | while read file
	do
		file=${file#*:}
		CMD="unix2dos.exe $file"
		echo $CMD; $CMD
	done
	find . -iname "*"\-wip"*"
}

#########################################
# Update repository submodules 
# recursively
#########################################
git_submodule_update() {
	CMD="git submodule update --init --recursive "$1; echo $CMD; $CMD
	CMD="git pull --recurse-submodules"; echo $CMD; $CMD
}




#########################################
# Show wip file, with specific pattern
#########################################
git_wip_ls () {
	export WIP_LIST
	pattern=$1
	pattern="\-$WIP_PREFIX-$pattern"
	git status -s | grep --color=never "$pattern" | while read file
	do
		f1=${file##*$WIP_PREFIX-}
		f1=${file%.*}
		wip=${f1##*-}
		WIP_LIST=( "$WIP_LIST" "$wip"  )
		echo WIP_LIST IN=${WIP_LIST[@]}
	done
	echo WIP_LIST OUT=${WIP_LIST[@]}
}


#########################################
# Compare a backup wip file, with the 
# same "not wip" file
#########################################
git_wip_cmp () {
do_cmp=true
pattern1=$1
pattern2=$2
	git status -s | grep --color=never "$pattern1" | grep --color=never "\-$WIP_PREFIX" | while read file_p1
	do
		file_p1=${file_p1#*:}
		name=$(file_get_name $file_p1)
		ext=$(file_get_ext $file_p1)
		if [[ "$pattern2" == "" ]]; then
			# No 2nd pattern, compare with filename.ext
			file_p2=$name.$ext
		else
			# 2nd pattern exist, compare with filename-WIP-'pattern2'.ext
			file_p2=$name-$WIP_PREFIX-$pattern2.$ext
		fi
		if [ ! -f "$file_p1" ]
		then
			echo "$file_p1 does not exist"
			do_cmp=false
		fi
		if [ ! -f "$file_p2" ]
		then
			echo "$file_p2 does not exist"
			do_cmp=false
		fi
		if [[ $do_cmp ]]; then
			CMD="meld $file_p1 $file_p2&"
			echo $CMD
			$CMD
		fi
	done
}

#########################################
# Rename extension of backup wip file, by
# adding a pattern
#########################################
git_wip_rename() {
	old_pattern="$1"
	new_pattern="$2"
	if [[ old_pattern == "" || "$new_pattern" == "" ]];then
		echo "2 parameters requested (old pattern and new pattern)"
	fi
	new_pattern="$WIP_PREFIX-$new_pattern"
	git status -s | grep --color=never $old_pattern | grep --color=never "\-$WIP_PREFIX" | while read file
	do
		file=${file#*:}
		name=$(file_get_name $file)
		ext=$(file_get_ext $file)
		file1=$file
		file2=$name-$new_pattern.$ext
		CMD="mv $file $file2"
		echo $CMD; $CMD
	done
}
#########################################
# Show wip file, with specific pattern
#########################################
git_wip_restore () {
	pattern=$1
	if [[ "$pattern" != "" ]];then
		pattern="\-$WIP_PREFIX-$pattern"
	fi
	echo -e $GREEN"Following file will replace original."$ATTR_RESET
	git status -s | grep --color=never "$pattern" | while read file
	do
		file=${file#*:}
		name=$(file_get_name $file)
		ext=$(file_get_ext $file)
		CMD="copy $file -> $name.$ext"
		echo $CMD
	done
	echo -e $GREEN
	read -e -i "N" -p "Ok? (y/N): "
	echo -e $ATTR_RESET
	if [[ "$REPLY" == "y" || "$REPLY" == "Y" ]]; then
		git status -s | grep --color=never "$pattern" | while read file
		do
			file=${file#*:}
			name=$(file_get_name $file)
			ext=$(file_get_ext $file)
			CMD="cp $file $name.$ext"
			echo $CMD
			$CMD
	done
	fi
}

#########################################
# Remove wip file
#########################################
git_wip_rm () {
	pattern=$1
	if [[ "$pattern" != "" ]];then
		pattern="\-$WIP_PREFIX-$pattern"
	fi
	git_rm_pattern "$pattern"
}

#########################################
# Copy modified files before a pull
# (Avoiding difficult merge)
#########################################
git_wip_save () {
	pattern="$1"
	pattern="-$WIP_PREFIX-"$pattern
	git status -s | grep --color=never "modified" | while read file
	do
		file=${file#*:}
		name=${file%.*}
		ext=${file##*.}
		CMD="cp $file $name$pattern.$ext"
		echo $CMD; $CMD
	done
	find . -iname "*"-$pattern"*"
}


############################################################
## Background 
############################################################
GITMON_FILE="$HOME/.gitmonitor"
git_monitor() {
	echo git_monitor
}

gitps1_add_remote_modif() {
	GIT_REMOTE_MODIF="[$(git_remote_get_modif)]: "
}

gitps1_remote_rm_modif() {
	unset GIT_REMOTE_MODIF
}

gitps1_update_aheadBehind() {
	isGit=$1
	unset GIT_AHEAD
	unset GIT_BEHIND
	if [[ "$isGit" ]]; then
		local_remote=$(eval git rev-list --left-right --count "$BRANCH...origin/$BRANCH 2>/dev/null")
		local_remote=$(echo $local_remote | sed 's/ /;/g')
		GIT_AHEAD=$(echo ${local_remote%;*})
		GIT_BEHIND=$(echo ${local_remote#*;})
	fi
}

gitps1_update_branch() {
	isGit=$1
	unset BRANCH
	if [[ "$isGit" ]]; then
		BRANCH=$(cat $repoGit/HEAD)
		BRANCH=${BRANCH##*heads/}
	fi
}

gitps1_update_stash() {
	isGit=$1
	unset GIT_STASH
	unset GIT_STASH_BRANCH
	if [[ "$isGit" ]]; then
		if [[ -e "$repoGit/logs/refs/stash" ]]; then
			## 'Global' Stash (wathever the branch)
			GIT_STASH=$(cat $repoGit/logs/refs/stash | wc -l 2>/dev/null)
			## Stash specific to a branch (GIT_STASH_BRANCH)
			GIT_STASH_BRANCH=$(cat $repoGit/logs/refs/stash | grep --color=never -w $BRANCH | wc -l 2>/dev/null)
			if [[ "$GIT_STASH_BRANCH" == "0" ]]; then
				unset GIT_STASH_BRANCH
			fi
		fi
	fi
}


alias gitps1_restore=ps1_restore

GIT=$(which git)
if [[ "$GIT" != "" ]]; then
    $SCRIPTS_PATH/git-aliases.sh
    source $SCRIPTS_PATH/git-completion.bash
fi

echo -e $YELLOW"Out of '.BASHRC_GIT'"$ATTR_RESET
