echo REPO=%1 > ./sourcetree_custom.log
echo FILE=%2 >> ./sourcetree_custom.log
echo SHA=%3 >> ./sourcetree_custom.log
echo BRANCH=%3 >> ./sourcetree_custom.log
C:\WINDOWS\system32\notepad.exe ./sourcetree_custom.log&
exit 0