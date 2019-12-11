FILE=$1
ftp -i -n ftpperso.free.fr << END_SCRIPT
quote USER fpaut
quote PASS w0je9vxt
pwd
put $FILE
quit
END_SCRIPT