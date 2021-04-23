#!/bin/bash
source $SCRIPTS_PATH/.bash_tools.sh > /dev/null
ZIP_FILE="./ssh.zip"
CMDE="zip -P \"Transalp1*\" "$ZIP_FILE" -r ./ssh"
exec "$CMDE"
