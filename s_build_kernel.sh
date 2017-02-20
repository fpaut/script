check_config() {
    local read=$1
    local check=$2
    
    echo -n "Checking $check? : "
    cfg_read=$(cat .config | grep --word-regexp "$read")
    if [ "$cfg_read" = "" ]; then
        read -e -i "Y" -p "$read not found in .config. Ignore ('Y'es / 'n'o): "
        if [[ "$REPLY" = "Y" || "$REPLY" = "y" ]]; then
            return
        fi
    fi
    if [ "$cfg_read" != "$check" ]; then
        echo "$cfg_read <> $check. Exiting"
        exit 1
    else
        echo "yes!"
    fi
}

if [ ! -e .config ]; then
    CMD="cp /boot/config-3.16.0-38-generic .config"; echo $CMD; eval "$CMD"
    CMD="make oldconfig"; echo $CMD; eval "$CMD"
fi
check_config "CONFIG_NFC" "CONFIG_NFC=m"
check_config "CONFIG_NFC_NCI" "CONFIG_NFC_NCI=m"
check_config "CONFIG_NFC_HCI" "CONFIG_NFC_HCI=m"
check_config "CONFIG_NFC_SHDLC" "CONFIG_NFC_SHDLC=y"
check_config "CONFIG_NFC_LLCP" "CONFIG_NFC_LLCP=y"
check_config "CONFIG_NFC_PN544" "CONFIG_NFC_PN544=m"
check_config "CONFIG_NFC_PN533" "CONFIG_NFC_PN533=m"
check_config "CONFIG_NFC_WILINK" "CONFIG_NFC_WILINK=m"

read -e -i "N" -p "Cleaning package ? ('Y'es / 'n'o): "
if [[ "$REPLY" = "Y" || "$REPLY" = "y" ]]; then
    CMD="make-kpkg clean"; echo "========================================================="; echo $CMD; eval "$CMD"; err=$?; echo 
    
    if [ "$err" != "0" ]; then
        echo "Error running $CMD"
        echo "Exiting..."
        exit 1
    fi
fi

CMD="CONCURRENCY_LEVEL=$(($(getconf _NPROCESSORS_ONLN)+1)) fakeroot make-kpkg --initrd --append-to-version=-nfc kernel_image kernel_headers"; echo "========================================================="; echo $CMD; eval "$CMD"; err=$?; echo 
if [ "$err" != "0" ]; then
    echo "Error running $CMD"
    echo "Exiting..."
    exit 1
fi

CMD="make modules"; echo "========================================================="; echo $CMD; eval $CMD; err=$?; echo 
if [ "$err" != "0" ]; then
    echo "Error running $CMD"
    echo "Exiting..."
    exit 1
fi


CMD="sudo make modules_install"; echo "========================================================="; echo $CMD; eval $CMD; err=$?; 
if [ "$err" != "0" ]; then
    echo "Error running $CMD"
    echo "Exiting..."
    exit 1
fi

CMD="sudo dpkg -i ../linux-{headers,image}-3.*.deb"; echo "========================================================="; echo $CMD; eval $CMD; echo 
err=$?
if [ "$err" != "0" ]; then
    echo "Error running $CMD"
    echo "Exiting..."
    exit 1
fi


