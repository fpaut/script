DIFF=$(diff $HOME/bin/aosp_repo $HOME/bin/repo)
if [ "$DIFF" != "" ]; then
	echo "Star Peak Repo tools selected"
else
	echo "AOSP Repo tools selected"
fi
