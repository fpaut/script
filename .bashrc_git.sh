echo
echo In BASHRC_GIT
####################################################################################################################################################################
## "GIT 'CONFIGURATION' section (in bash command line, different from .gitconfig)
####################################################################################################################################################################
alias git='LANG=en_GB git'
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
		exit 1
	fi
	if [[ "$rev2" == "" ]]; then
		rev2="HEAD"
	fi
	CMD="git diff $rev1 $rev2"
	echo $CMD && $CMD
}

git_diff_show_file(){
	branch=$1
	pattern=$2
	git diff "$branch" | grep diff | grep "$pattern" | while read item
	do
		file=${item##* b/}
		echo $file
	done
}

git_diff_cmp(){
	branch=$1
	pattern=$2
	git diff "$branch" | grep diff | grep "$pattern" | while read item
	do
		file=${item##* b/}
		echo file
		echo $file | hexdump
		CMD="git difftool $branch -- $file"
		echo $CMD && $CMD
	done
}

git_get_branch () {
	BRANCH=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/[\1]/')
	BRANCH=${BRANCH:1:$((${#BRANCH} - 2))}
	echo "$BRANCH"
}

#########################################
# Copy modified files before a pull
# (Avoiding difficult merge)
#########################################
git_dos2unix () {
	git status -s | grep "modified" | grep -v "\-wip" | while read file
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
	CMD="cp $HOME/dev/scripts/.gitconfig $HOME"
	echo $CMD
	$CMD
}

git_discard () {
	file_pattern=$1
	[[ "$file_pattern" == "" ]] && echo missing file pattern to discard as first parameter &&  return 1
	if [[ "$file_pattern" == "all" ]]; then
		file_pattern=""
	fi
	git status -s | grep --color=never "$file_pattern" | grep  --color=never  -v "$WIP_PREFIX" | while read file
	do
		file=${file##* }
		file=${file#*:}
		[[ "$file" != "" ]] && CMD="git checkout -- $file"
		echo $CMD; $CMD
	done
}

git_reset () {
	file_pattern=$1
	[[ "$file_pattern" == "" ]] && echo missing file pattern to discard as first parameter &&  return 1
	if [[ "$file_pattern" == "all" ]]; then
		file_pattern=""
	fi
	echo -e $GREEN"Following file will be reseted to HEAD."$ATTR_RESET
	git status -s | grep --color=never "$file_pattern" | grep ":" | grep  --color=never  -v "$WIP_PREFIX" | while read file
	do
		file=${file#*:}
		CMD=" $file "
		echo $CMD
	done
	echo -e $GREEN
	read -e -i "N" -p "Ok? (y/N): "
	echo -e $ATTR_RESET
	if [[ "$REPLY" == "y" || "$REPLY" == "Y" ]]; then
		git status -s | grep --color=never "$file_pattern" | grep ":" | grep  --color=never  -v "$WIP_PREFIX" | while read file
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

git_remote_count_commit () {
	unset REMOTE AHEAD BEHIND
	BRANCH=$(git_get_branch)
 	AHEAD=$(git commit --dry-run 2>/dev/null | grep ahead)
 	BEHIND=$(git commit --dry-run 2>/dev/null | grep behind)
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
	GITSTATUS=$(git status -uno | grep branch)
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
	path=$(dirname $file)
	filename=$(basename $file)
	name=${filename%.*}
	ext=${filename#*.}
	
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
	F_REMOTE_BRANCH=($(eval "git remote show $REMOTE | grep ' $BRANCH '  | grep 'merge'"))
	REMOTE_BRANCH=${F_REMOTE_BRANCH[4]}
	eval "git log $REMOTE/$REMOTE_BRANCH..HEAD"
}
####################################################################################################################################################################
## "GIT STASH" section : Utilities functions to manipulate files present in git stash list
####################################################################################################################################################################
git_sh_cmp() 
{
	STASH="$1"
	git stash show $STASH | grep "|"  | while read file
	do 
		file=${file%% |*}
		CMD="git difftool -y $STASH -- $file"
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
	LANG=en_GB git stash show $stash | grep "|" | while read file
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

git_st_cmp () {
do_cmp=false
pattern1=$1
pattern2=$2
	git status -s | grep --color=never "$pattern1" | while read file_p1
	do
		do_cmp=false
		file_p1=${file_p1##* }
		path=$(file_get_path $file_p1)
		name=$(file_get_name $file_p1)
		ext=$(file_get_ext $file_p1)
		echo "name=$name"
		echo "ext=$ext"
		if [[ "$pattern2" == "" ]]; then
			# No 2nd pattern, compare with filename.ext
			file_p2=${file_p1%%$pattern1*}.$ext
		else
			# 2nd pattern exist, compare with filename'pattern2'.ext
			file_p2=$path/$name$pattern2.$ext
		fi
		if [[ ! -f "$file_p1" ]]
		then
			echo "$file_p1 does not exist"
		fi
		if [[ ! -f "$file_p2" ]]
		then
			echo "$file_p2 does not exist"
		fi
		file_p1=$(conv_path_for_win $file_p1)
		file_p1=$(double_backslash "$file_p1")
		file_p2=$(conv_path_for_win $file_p2)
		file_p2=$(double_backslash "$file_p2")
		echo "file_p1=$file_p1"
		echo "file_p2=$file_p2"
		CMD="diff $file_p1 $file_p2 1>/dev/null"
		echo $CMD; eval $CMD
		case  "$?" in
			"0")
				echo -e "$GREEN $file_p1 is identical to $file_p2$ATTR_RESET"
				do_cmp=false
			;;
			"1")
				echo -e "$BLUE $file_p1 is different to $file_p2 $ATTR_RESET"
				do_cmp=true
			;;
			"2")
			echo -e "$RED Error on diff command ! (Files not found?) $ATTR_RESET"
			echo -e "$RED $CMD $ATTR_RESET"
			;;
		esac
		if [[ "$do_cmp" != "false" ]]; then		
			CMD="$GIT_DIFFTOOL $file_p1 $file_p2 1>/dev/null 2>/dev/null&"
			echo $CMD; eval $CMD
		fi
	done
}

#########################################
# Rename extension of backup wip file, by
# adding a pattern
#########################################
git_st_rename() {
	old_pattern="$1"
	new_pattern="$2"
	if [[ old_pattern == "" || "$new_pattern" == "" ]];then
		echo "2 parameters requested (old pattern and new pattern)"
	fi
	new_pattern="$new_pattern"
	git status -s | grep $old_pattern | while read file
	do
		file=${file##* }
		file=${file#*:}
		name=${file%$pattern1*}
		ext=${file#*.}
		file1=$file
		file2=$name$new_pattern.$ext
		CMD="mv $file $file2"
		echo $CMD; $CMD
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
	git status -s | grep "$pattern" | while read file
	do
		file=${file##* }
		file=${file#*:}
		name=${file%$pattern*}
		ext=${file#*.}
		CMD="copy $file -> $name.$ext"
		echo $CMD
	done
	echo -e $GREEN
	read -e -i "N" -p "Ok? (y/N): "
	echo -e $ATTR_RESET
	if [[ "$REPLY" == "y" || "$REPLY" == "Y" ]]; then
		git status -s | grep "$pattern" | while read file
		do
			file=${file#*:}
			name=${file%$pattern*}
			CMD="cp $file $name.$ext"
			echo $CMD
			$CMD
		done
	fi
	echo -e $GREEN
	read -e -i "N" -p "Remove Backup ($pattern)? (y/N): "
	echo -e $ATTR_RESET
	if [[ "$REPLY" == "y" || "$REPLY" == "Y" ]]; then
		git status -s | grep "$pattern" | while read file
		do
			file=${file#*:}			
			CMD="rm $file"
			echo $CMD
			$CMD
		done
	fi
}

#########################################
# Delete file referenced by git following 
# 'pattern'
#########################################
git_st_rm () {
	local found=false
	pattern=$1
	echo "searching pattern '$pattern'"
	[[ $pattern == "" ]] && echo missing pattern as parameter &&  return 1
	echo -e $GREEN"Following file will be removed."$ATTR_RESET
	test=$(
	git status -s | grep  --color=never "$pattern" | while read file
	do
		file=${file##* }
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
			git status -s | grep --color=never $pattern | while read file
			do
				file=${file##* }
				file=${file#*:}
				CMD="rm -rf \"$file\""
				echo $CMD;
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
	git status -s | grep --color=never $pattern | grep  --color=never -v "$WIP_PREFIX" | while read file
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
	git status -s | grep "M " | while read file
	do
		file=${file##* }
		file=${file#*:}
		name=${file%.*}
		ext=${file##*.}
		CMD="cp $file $name$pattern.$ext"
		echo $CMD; 
		$CMD
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
	branch=$(git branch | grep "\*")
	branch=${branch#*\*}
	git show --pretty="" --name-only $rev | while read file
	do
		name=${file%.*};
		ext=${file#*.};
		CMD="git show $rev:$file > $name-$pattern.$ext"
		echo $CMD; eval "$CMD"
	done
	ls -halF | grep $pattern
}

#########################################
# Execute parameterized command on file
# found with "git status" command, 
# filtered with parameter 'pattern'
#########################################
git_stp () {
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


git_unix2dos () {
	git status -s | grep "modified" | grep -v "\-wip" | while read file
	do
		file=${file#*:}
		CMD="unix2dos.exe $file"
		echo $CMD; $CMD
	done
	find . -iname "*"\-wip"*"
}


####################################################################################################################################################################
## "WIP section" Utilities functions to manipulate Work In Progress files combined with GIT
####################################################################################################################################################################
WIP_PREFIX="WIP"

#########################################
# Show wip file, with specific pattern
#########################################
git_wip_ls () {
	export WIP_LIST
	pattern=$1
	pattern="\-$WIP_PREFIX-$pattern"
	git status -s | grep "$pattern" | while read file
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
# Get name of a 'wip' file
#########################################
git_wip_get_file_name () {
	file=$1
	echo  ${file%-$WIP_PREFIX*}
}

#########################################
# Get extension of a 'wip' file
#########################################
git_wip_get_file_ext () {
	file=$1
	echo ${file##*.}
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
		name=$(git_wip_get_file_name $file_p1)
		ext=$(git_wip_get_file_ext $file_p1)
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
	git status -s | grep $old_pattern | grep "\-$WIP_PREFIX" | while read file
	do
		file=${file#*:}
		name=$(git_wip_get_file_name $file)
		ext=$(git_wip_get_file_ext $file)
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
	git status -s | grep "$pattern" | while read file
	do
		file=${file#*:}
		name=$(git_wip_get_file_name $file)
		ext=$(git_wip_get_file_ext $file)
		CMD="copy $file -> $name.$ext"
		echo $CMD
	done
	echo -e $GREEN
	read -e -i "N" -p "Ok? (y/N): "
	echo -e $ATTR_RESET
	if [[ "$REPLY" == "y" || "$REPLY" == "Y" ]]; then
		git status -s | grep "$pattern" | while read file
		do
			file=${file#*:}
			name=$(git_wip_get_file_name $file)
			ext=$(git_wip_get_file_ext $file)
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
	git status -s | grep "modified" | while read file
	do
		file=${file#*:}
		name=${file%.*}
		ext=${file##*.}
		CMD="cp $file $name$pattern.$ext"
		echo $CMD; $CMD
	done
	find . -iname "*"-$pattern"*"
}

is_git_folder() {
	repoGit=$(git rev-parse --git-dir 2>/dev/null)
	[ -d .git ] || [[ "$repoGit" != "" ]] && echo "$repoGit"
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
		GIT_AHEAD=${local_remote:0:1}
		GIT_BEHIND=$(echo ${local_remote:1} | sed 's/ //g')
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
			GIT_STASH_BRANCH=$(cat $repoGit/logs/refs/stash | grep -w $BRANCH | wc -l 2>/dev/null)
			if [[ "$GIT_STASH_BRANCH" == "0" ]]; then
				unset GIT_STASH_BRANCH
			fi
		fi
	fi
}

alias gitps1_restore=ps1_restore


echo Out of BASHRC_GIT
