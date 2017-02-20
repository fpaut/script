#! /bin/bash
usage() { echo; echo "Usage: "$(basename $0)" -d device -s system image -r recovery image [-o oem image] [-m size of RAM]" 1>&2; echo $(basename $0)" -d /dev/sdb -s ./system.img -r recovery.img -o ./oem.img -m 2147483648" 1>&2; echo; exit 1; }

function parse_option {
   while getopts "d:s:r:o:m:" o; do
      case "${o}" in
	  d)
	      DEVICE=${OPTARG}
	      ;;
	  s)
	      PART_SYST_IMG_FILE=${OPTARG}
	      ;;
	  r)
	      PART_UEFIBOOT1_IMG_FILE=${OPTARG}
	      PART_UEFIBOOT2_IMG_FILE=$PART_UEFIBOOT1_IMG_FILE
	      ;;
	  o)
	      PART_OEM_IMG_FILE=${OPTARG}
	      ;;
	  m)
	      PART_IRS_SIZE=${OPTARG}
	      ;;
	  *)
	      usage
	      ;;
      esac
  done
  shift $((OPTIND-1))

  if [ -z "${DEVICE}" ] || [ -z "${PART_SYST_IMG_FILE}" ] || [ -z "PART_UEFIBOOT1_IMG_FILE" ]; then
      usage
  fi
}

function debug {
    echo -e "debug : "$@ > /dev/stderr
}

function check_tool {
    ERR=0
    CMD=$@
    TOOL=${CMD%%" "*}
    debug "CMD="$CMD
    debug "TOOL="$TOOL
    $(eval $CMD)> /dev/null
    ERR=$?
    if [ $ERR ]; then
      echo $TOOL > ./$MISS_TOOL
    fi
    echo $ERR
    exit
}

function check_dependencies {
    rm $MISS_TOOL
    ERR=0
    
    ERR=$(echo "$ERR + $(check_tool 'mkfs.btrfs -V 2>/dev/null')" | bc)
    ERR=$(echo "$ERR + $(check_tool 'fdisk -v 2>/dev/null')" | bc)
    ERR=$(echo "$ERR + $(check_tool 'mkfs.ext2  -V 2>/dev/null')" | bc)
    ERR=$(echo "$ERR + $(check_tool 'mkfs.ext3  -V 2>/dev/null')" | bc)
    ERR=$(echo "$ERR + $(check_tool 'mkfs.ext4  -V 2>/dev/null')" | bc)
    ERR=$(echo "$ERR + $(check_tool 'mkfs.btrfs -V 2>/dev/null')" | bc)
    ERR=$(echo "$ERR + $(check_tool 'mkfs.vfat  -v 1>/dev/null')" | bc)
    ERR=$(echo "$ERR + $(check_tool 'blockdev -V 1>/dev/null')" | bc)
    
    debug "ERR="$ERR
    if [ $ERR -ge 100 ];then
      cat $MISS_TOLL
      exit
    fi
}

function extract {
    STRING=$1
    DELIM_START=$2
    DELIM_END=$3
##    printf "STRING='%s'\nDELIM_START='%s'\nDELIM_END='%s'\n" "$STRING" "$DELIM_START" "$DELIM_END"
    before=${STRING%%$DELIM_START*}
    before_len=$(echo ${#before} + ${#DELIM_START} | bc)
    rest_of_string=${STRING:$before_len:${#STRING}}
    debug "STRING="$STRING
    debug "DELIM_START="$DELIM_START
    debug "DELIM_END="$DELIM_END
    debug "before="$before
    debug "before_len="$before_len
    debug "rest_of_string="$rest_of_string
##    printf "before='%s'\nrest_of_string='%s'\n\n" "$before" "$rest_of_string"
    after=${rest_of_string%%$DELIM_END*}
##    printf "before='%s'\nafter='%s'\n" "$before" "$after"
    debug "after="$after
}

function progress_bar {
  interval=0.5"s"
  long_interval=10
  {
     sleep $interval; sleep $interval
     while true
     do
       echo -n '.'     # Use dots.
       sleep $interval
     done; 
   }
}

function progress_bar_kill {
    if [ $pb_pid ]; then
      # Stop the progress bar.
      kill $pb_pid
      wait $pb_pid
      unset pb_pid
    fi
}

function def_font_attributes {
    ATTR_RESET="\e[0m"
    ATTR_UNDERLINED="\e[4m"
      
    FONT_BOLD="\e[1m"

    BKG_RED="\e[41m"
    BKG_GREEN="\e[42m"
    BKG_BLUE="\e[44m"
    
    FONT_BLACK="\e[30m"
    FONT_RED="\e[91m"
    FONT_GREEN="\e[92m"
    FONT_YELLOW="\e[93m"
    FONT_BLUE="\e[34m"
    FONT_CYAN="\e[96m"
    FONT_WHITE="\e[97m"
}

function backtrace
{
    local _start_from_=0

    local params=( "$@" )
    if (( "${#params[@]}" >= "1" ))
        then
            _start_from_="$1"
    fi

    local i=0
    local first=false
    while caller $i > /dev/null
    do
        if test -n "$_start_from_" && (( "$i" + 1   >= "$_start_from_" ))
            then
                if test "$first" == false
                    then
                        echo "BACKTRACE IS:"
                        first=true
                fi
                caller $i
        fi
        let "i=i+1"
    done
}

function exit_handler {
  local ERR_CODE="${1:-1}"
  local CMD=$2
  local ERR_STR=$3
  
  progress_bar_kill
  
  if [[ -n "$ERR_STR" ]] ; then
    echo -e "Error : "$FONT_BLUE${CMD}$ATTR_RESET" exiting with status "${ERR_CODE}" and error message "$FONT_RED$ERR_STR$ATTR_RESET
  else
    echo -e "Error : "$FONT_BLUE${CMD}$ATTR_RESET" exiting with status "${ERR_CODE}$ATTR_RESET
  fi
  _backtrace=$( backtrace 2 )
  echo -e "\n$_backtrace\n"

  kill -l ${ERR_CODE}
}


function EXE_R {
  CMD=$@
  CMD=$CMD
  LOG_CLR=">>>> Processing command "$FONT_BOLD$BKG_BLUE$CMD$ATTR_RESET
  echo -e $LOG_CLR
  RESULT=$(eval $CMD)
  ERR_CODE=$?
  if [ $ERR_CODE != 0 ]; then 
      ERROR $ERR_CODE "$CMD" "${RESULT#*": "}"
  fi
  
  echo $RESULT
  return $ERR_CODE
}

function EXE {
  CMD=$@
  CMD=$CMD
  LOG_CLR=">>>> Processing command "$FONT_BOLD$BKG_BLUE$CMD$ATTR_RESET
  echo -e $LOG_CLR
  eval $CMD
  ERR_CODE=$?
  if [ $ERR_CODE != 0 ]; then 
      ERROR $ERR_CODE "$CMD" "${RESULT#*": "}"
  fi
  
  return $ERR_CODE
}


function handle_trap {
  trap "exit_handler '"$@"'" $@
}
     
function init {
    def_font_attributes
    parse_option $@
    check_dependencies
     
    # ! ! ! TRAP List ! ! !
    set -e
    handle_trap SIGUSR1
    handle_trap ERR
    handle_trap SIGHUP
    handle_trap SIGINT
    handle_trap SIGQUIT
    handle_trap SIGILL
    handle_trap SIGKILL
    handle_trap SIGTRAP
    handle_trap SIGABRT
    GB_TO_B="* 1024 * 1024 * 1024"
    MB_TO_B="* 1024 * 1024"
    B_TO_MB="/ 1024 / 1024"
    B_TO_KB="/ 1024 / 1024"
    MB_TO_KB="* 1024"
}

function get_device {
    RESULT=$(sudo fdisk -l | grep Disk | grep byte)
    while [ ${#RESULT} -ge 1 ]; do
	before=${RESULT%%"/"*}
	after=${RESULT#*":"}    
	cut_len=$(expr ${#RESULT} - $(expr ${#before} + ${#after}) - 1)
	if [[ $cut_len -ge "0" ]]; then
	  if [ -z $DEVICE ]; then
	    export DEVICE=${RESULT:${#before}:$cut_len}
	  else
	    export DEVICE=${RESULT:${#before}:$cut_len}"\n"$DEVICE
	  fi
	  RESULT=${RESULT:$(expr $cut_len + ${#before} + 1 ):${#RESULT}}
	  export RESULT
	else
	  RESULT=${RESULT:${#RESULT}:${#RESULT}}
	fi
    done
    export RESULT=$DEVICE
}

function check_alignment {
  VAL=$1
  CMD="echo '"$VAL"' % '"$SECTOR_SIZE"' | bc"
  RESULT=$(eval $CMD)
  if [[ "$RESULT" != "0" ]]; then
    echo -e $FONT_RED"EXIT FROM check_alignment!!" $ATTR_RESET
    kill -SIGUSR1 $$
  fi  
}

function create_part {
    # $1 = Device name (/dev/sdX)
    # $2 = Partition Number (1..x)
    # $3 = Partition start = offset in MB
    # $4 = Partition size = in MB
    # $5 = Partition type = ext2, ext3, ext4...
    # $6 = Partition Label = Volume name
    # $7 = Partition Bootable (optionnal or 0/1)
    echo
    echo "create_part "$@
    DEVICE=$1
    PART_NB=$2
    PART_START=$3
    PART_END=$4
    PART_SIZE=$(echo "$PART_END - $PART_START" | bc -l)
    PART_FS_TYPE=$5
    PART_LABEL=$6
    PART_BOOT=$7

    ## Partition Size? : start (in MB)
    if [ -z $PART_START ]; then
      DEFAULT=0
      read -e -i $DEFAULT -p "Partition Start (MB)? : "
      PART_START=$REPLY
    fi

    ## Partition Size? : end (in MB)
    if [ -z $PART_END ]; then
      DEFAULT=256
      read -e -i $DEFAULT -p "Partition End (MB)? : "
      PART_END=$REPLY
    fi

    ## Partition FS Type?
##     if [ -z $PART_FS_TYPE ]; then
##       DEFAULT="ext3"
##       read -e -i $DEFAULT -p "Partition filesystem type? : "
##       PART_FS_TYPE=$REPLY
##     fi

    ## Partition Label?
    if [[ "w"$PART_LABEL = "w" ]]; then
      DEFAULT=""
      read -e -i $DEFAULT -p "Partition Label? : "
      PART_LABEL=$REPLY
    fi

    # Check if device exists
    test -b $DEVICE
    # Create partition
    echo
    echo -e $FONT_BLUE"Create Partition "$FONT_GREEN $PART_LABEL $ATTR_RESET" :"
    echo -e "Sector size :"$FONT_GREEN $SECTOR_SIZE"B"$ATTR_RESET
    echo -e "Number :"$FONT_GREEN $PART_NB $ATTR_RESET
    PART_MB=$(echo "$PART_SIZE $B_TO_MB" | bc)
    echo -e "Size   :"$FONT_GREEN $PART_MB $ATTR_RESET"MB"
    echo -e "From   "$FONT_GREEN $PART_START" bytes= "$(echo "$PART_START $B_TO_MB" | bc)"MB " $ATTR_RESET" to " $FONT_GREEN $PART_END" bytes= "$(echo "$PART_END $B_TO_MB" | bc)"MB " $ATTR_RESET
    
##    check_alignment $PART_START
##    check_alignment $PART_END
    
    # Convert in number of sectors
    SECTOR_START=$(echo "$PART_START / $SECTOR_SIZE" | bc)
    SECTOR_END=$(echo "$PART_END / $SECTOR_SIZE" | bc)
    echo -e "From   sector "$FONT_GREEN$SECTOR_START$ATTR_RESET" to sector "$FONT_GREEN$SECTOR_END$ATTR_RESET
    echo "sudo parted -s --align minimal "$DEVICE" mkpart primary " $SECTOR_START"s" $SECTOR_END"s"
    sudo parted -s --align minimal $DEVICE mkpart primary $SECTOR_START"s" $SECTOR_END"s"
    
    # Format partition
    if [ $PART_FS_TYPE ]; then
      echo -e $FONT_BLUE"Format Partition in "$FONT_GREEN $PART_FS_TYPE $ATTR_RESET
    fi
    echo -e $FONT_RED
    case $PART_FS_TYPE in
      "ext2")
         echo "sudo mkfs.ext2 -j -L "$PART_LABEL $DEVICE$PART_NB
	 echo -e $ATTR_RESET
         sudo mkfs.ext2 -L $PART_LABEL $DEVICE$PART_NB 1>/dev/null;; 
      "ext3")
         echo "sudo mkfs.ext3 -j -L "$PART_LABEL $DEVICE$PART_NB
	 echo -e $ATTR_RESET
         sudo mkfs.ext3 -L $PART_LABEL $DEVICE$PART_NB 1>/dev/null;;
      "ext4")
         echo "sudo mkfs.ext4 -j -L "$PART_LABEL $DEVICE$PART_NB
	 echo -e $ATTR_RESET
         sudo mkfs.ext4 -L $PART_LABEL $DEVICE$PART_NB 1>/dev/null;;
       "fat16")
         echo "sudo mkfs.vfat -F 16 -n "$PART_LABEL" -v "$DEVICE$PART_NB
 	 echo -e $ATTR_RESET
         sudo mkfs.vfat -F 16 -n $PART_LABEL -v $DEVICE$PART_NB 1>/dev/null;;
       "fat32")
         echo "sudo mkfs.vfat -F 32 -n "$PART_LABEL" -v "$DEVICE$PART_NB
 	 echo -e $ATTR_RESET
         sudo mkfs.vfat -F 32 -n $PART_LABEL -v $DEVICE$PART_NB 1>/dev/null;;
       "btrfs")
         echo "sudo mkfs.btrfs --label "$PART_LABEL $DEVICE$PART_NB
 	 echo -e $ATTR_RESET
         sudo mkfs.btrfs --label $PART_LABEL $DEVICE$PART_NB 1>/dev/null;;
       "cramfs")
         echo "sudo mkcramfs -n "$PART_LABEL $DEVICE$PART_NB
 	 echo -e $ATTR_RESET
         sudo mkcramfs -n $PART_LABEL $DEVICE$PART_NB 1>/dev/null;;
       "none")
         echo $DEVICE$PART_NB $PART_LABEL " unformatted and unamed"
 	 echo -e $ATTR_RESET
## 	 sudo tune2fs -L $PART_LABEL $DEVICE$PART_NB
## 	 sudo e2label $DEVICE$PART_NB $PART_LABEL 
    esac
          
    if [[ $PART_BOOT && $PART_BOOT != "0" ]]; then
      # Set attribute (partition bootable)
      echo -e $FONT_RED"sudo parted "$DEVICE" set "$PART_NB" boot on"$ATTR_RESET
      sudo parted $DEVICE set $PART_NB boot on
    fi
}

function get_img_files {
    echo "get_img_files"
    ## UEFI boot 1/2 img?
    if [ -z $PART_UEFIBOOT1_IMG_FILE ]; then
      DEFAULT="./boot.img"
      read -e -i $DEFAULT -p "Recovery image file 0/1? : "
      PART_UEFIBOOT1_IMG_FILE=$REPLY
    fi

    ## UEFI boot 2/2 img?
    if [ -z $PART_UEFIBOOT2_IMG_FILE ]; then
      DEFAULT="./fastboot.img"
      read -e -i $DEFAULT -p "Recovery image file 1/1? : "
      PART_UEFIBOOT2_IMG_FILE=$REPLY
    fi

    ## System img?
    if [ -z $PART_SYST_IMG_FILE ]; then
      DEFAULT="./system.img"
      read -e -i $DEFAULT -p "System image file? : "
      PART_SYST_IMG_FILE=$REPLY
    fi

  EXE_R sync
}

function align_to_sector {
  size=$2
  sector_dec=$(echo "$size / $SECTOR_SIZE" | bc -l)
  sector_int=$(echo "$size / $SECTOR_SIZE" | bc)
  rest=$(echo "$sector_dec - $sector_int" | bc -l)
  debug "sector to align= "$sector_dec" sector"
  if [ "$rest" != "0" ]; then
    next_sector=$(echo "1 + $sector_int" | bc)
    lost_bytes=$(echo "$SECTOR_SIZE - $rest" | bc -l)
  else
    next_sector=$sector_int
    lost_bytes=0
  fi
  next_sector_as_bytes=$(echo "$next_sector * $SECTOR_SIZE" | bc)
  debug "sector aligned= "$next_sector
  debug "next_sector_as_bytes= "$next_sector_as_bytes
  if [ $1 = "align" ]; then
    echo $next_sector_as_bytes
  else # lost bytes
    echo $lost_bytes
  fi
}

function align_to_MB {
  size=$2
  in_MB_dec=$(echo "$size $B_TO_MB" | bc -l)
  in_MB_int=$(echo "$size $B_TO_MB" | bc)
  rest=$(echo "$in_MB_dec - $in_MB_int" | bc -l)
  debug "MB to align= "$in_MB_dec" MB"
  if [ "$rest" != "0" ]; then
    in_MB=$(echo "1 + ($size / 1048576)" | bc)
    in_MB=$(echo "$in_MB $MB_TO_B" | bc)
  fi
  debug "MB aligned= "$(echo "$in_MB $B_TO_MB" | bc)" MB"
  if [ $1 = "align" ]; then
    echo $in_MB
  else
    echo $(echo "1 - $rest" | bc -l)
  fi
}

function partitionning {
    LOST_B_SIZE=0
    SECTOR_SIZE=$(sudo blockdev --getss /dev/sdb)
    PART_NB=1
    DEVICE_FREE_SIZE=$(sudo blockdev --getsize64 $DEVICE)
    debug $FONT_CYAN$ATTR_UNDERLINED"DEVICE_FREE_SIZE= "$(echo "$DEVICE_FREE_SIZE $B_TO_MB" | bc)" MB"$ATTR_RESET

## ------------------- Create Partition Table -------------------
    echo -e $FONT_BLUE"Create GPT Partition Table"$ATTR_RESET
    sudo parted -s $DEVICE mktable gpt

## ------------------- Partition UEFI boot/Recovery part1/2 -------------------
    PART_UEFIBOOT1_NB=$PART_NB
    PART_UEFIBOOT1_TYPE=fat16    
    PART_UEFIBOOT1_IMG_SIZE=$(stat -c %s $PART_UEFIBOOT1_IMG_FILE)
    PART_UEFIBOOT1_SIZE=$(echo "100 $MB_TO_B + $PART_UEFIBOOT1_IMG_SIZE" | bc)
    
    PART_START=$(echo "2048 * $SECTOR_SIZE" | bc)
    PART_END=$(echo "$PART_START + $PART_UEFIBOOT1_SIZE" | bc)
    REST=$(align_to_sector lost $PART_END)
    debug "REST="$REST
    PART_END=$(align_to_sector align $PART_END)
    LOST_B_SIZE=$(echo "$LOST_B_SIZE + $REST" | bc -l)
    debug "UEFI boot/Recovery1 Last sector="$(echo "$PART_END / $SECTOR_SIZE" | bc)
     
    create_part $DEVICE $PART_NB $PART_START $PART_END $PART_UEFIBOOT1_TYPE "UEFIBOOT1" 1
    
    # Adjust partition size
    PART_UEFIBOOT1_SIZE=$(echo "$PART_END - $PART_START" | bc)
    DEVICE_FREE_SIZE=$(echo "$DEVICE_FREE_SIZE - $PART_UEFIBOOT1_SIZE - 2048 * $SECTOR_SIZE" | bc)     # in bytes
    debug $FONT_CYAN$ATTR_UNDERLINED"DEVICE_FREE_SIZE= "$(echo "$DEVICE_FREE_SIZE $B_TO_MB" | bc)" MB"$ATTR_RESET
    echo -e $FONT_CYAN "END OF Partition UEFI boot/Recovery part1/2"$ATTR_RESET
 
## ------------------- Partition UEFI boot/Recovery part2/2 -------------------
    PART_NB=$(echo "$PART_NB + 1" | bc)
    PART_UEFIBOOT2_NB=$PART_NB
    PART_UEFIBOOT2_TYPE=fat16    
    PART_UEFIBOOT2_IMG_SIZE=$(stat -c %s $PART_UEFIBOOT2_IMG_FILE)
    PART_UEFIBOOT2_SIZE=$(echo "100 $MB_TO_B + $PART_UEFIBOOT2_IMG_SIZE" | bc)  # 100MB+recovery
    
    PART_START=$(echo "$PART_END + $SECTOR_SIZE" | bc)
    PART_END=$(echo "$PART_START + $PART_UEFIBOOT2_SIZE" | bc)
    REST=$(align_to_sector lost $PART_END)
    debug "REST="$REST
    PART_END=$(align_to_sector align $PART_END)
    LOST_B_SIZE=$(echo "$LOST_B_SIZE + $REST" | bc -l)
    debug "UEFI boot/Recovery2 Last sector="$(echo "$PART_END / $SECTOR_SIZE" | bc)
    
    create_part $DEVICE $PART_NB $PART_START $PART_END $PART_UEFIBOOT2_TYPE "UEFIBOOT2"
    
    # Adjust partition size
    PART_UEFIBOOT2_SIZE=$(echo "$PART_END - $PART_START" | bc)
    DEVICE_FREE_SIZE=$(echo "$DEVICE_FREE_SIZE - $PART_UEFIBOOT2_SIZE - $SECTOR_SIZE" | bc)     # in bytes
    debug $FONT_CYAN$ATTR_UNDERLINED"DEVICE_FREE_SIZE= "$(echo "$DEVICE_FREE_SIZE $B_TO_MB" | bc)" MB"$ATTR_RESET
    echo -e $FONT_CYAN "END OF Partition UEFI boot/Recovery part2/2"$ATTR_RESET

      
## ------------------- Partition /system -------------------
    PART_NB=$(echo "$PART_NB + 1" | bc)
    PART_SYST_NB=$PART_NB
    PART_SYST_SIZE=$(echo "2560 $MB_TO_B" | bc)		# 2.5GB
    PART_SYST_TYPE=btrfs
    
    PART_START=$(echo "$PART_END + $SECTOR_SIZE" | bc)
    PART_END=$(echo "$PART_START + $PART_SYST_SIZE" | bc)
    REST=$(align_to_sector lost $PART_END)
    debug "REST="$REST
    PART_END=$(align_to_sector align $PART_END)
    LOST_B_SIZE=$(echo "$LOST_B_SIZE + $REST" | bc -l)
    debug "system Last sector="$(echo "$PART_END / $SECTOR_SIZE" | bc)
    
    create_part $DEVICE $PART_NB $PART_START $PART_END $PART_SYST_TYPE "system" 1
    
    # Adjust partition size
    PART_SYST_SIZE=$(echo "$PART_END - $PART_START" | bc)
    DEVICE_FREE_SIZE=$(echo "$DEVICE_FREE_SIZE - $PART_SYST_SIZE - $SECTOR_SIZE" | bc)     # in bytes
    debug $FONT_CYAN$ATTR_UNDERLINED"DEVICE_FREE_SIZE= "$(echo "$DEVICE_FREE_SIZE $B_TO_MB" | bc)" MB"$ATTR_RESET
    echo -e $FONT_CYAN "END OF Partition /system"$ATTR_RESET

## ------------------- Partition /cache -------------------
    PART_NB=$(echo "$PART_NB + 1" | bc)
    PART_CACHE_NB=$PART_NB
    PART_CACHE_SIZE=$(echo "512 $MB_TO_B" | bc)	# 512MB
    PART_CACHE_TYPE=ext4
    
    PART_START=$(echo "$PART_END + $SECTOR_SIZE" | bc)
    PART_END=$(echo "$PART_START + $PART_CACHE_SIZE" | bc)
    REST=$(align_to_sector lost $PART_END)
    debug "REST="$REST
    PART_END=$(align_to_sector align $PART_END)
    LOST_B_SIZE=$(echo "$LOST_B_SIZE + $REST" | bc -l)
    debug "cache Last sector="$(echo "$PART_END / $SECTOR_SIZE" | bc)
   
    create_part $DEVICE $PART_NB $PART_START $PART_END $PART_CACHE_TYPE "cache"
    
    # Adjust partition size
    PART_CACHE_SIZE=$(echo "$PART_END - $PART_START" | bc)
    DEVICE_FREE_SIZE=$(echo "$DEVICE_FREE_SIZE - $PART_CACHE_SIZE - $SECTOR_SIZE" | bc)     # in bytes
    debug $FONT_CYAN$ATTR_UNDERLINED"DEVICE_FREE_SIZE= "$(echo "$DEVICE_FREE_SIZE $B_TO_MB" | bc)" MB"$ATTR_RESET
    echo -e $FONT_CYAN "END OF Partition /cache"$ATTR_RESET

## ------------------- Partition /oem -------------------
    if [ ! -z $PART_OEM_IMG_FILE ]; then
      PART_NB=$(echo "$PART_NB + 1" | bc)
      PART_OEM_NB=$PART_NB
      PART_OEM_SIZE=$(echo "1 $GB_TO_B" | bc)	# 1GB for now, but OEM dependant
      PART_OEM_TYPE=ext4
      
      PART_START=$(echo "$PART_END + $SECTOR_SIZE" | bc)
      PART_END=$(echo "$PART_START + $PART_OEM_SIZE" | bc)
      REST=$(align_to_sector lost $PART_END)
    debug "REST="$REST
      PART_END=$(align_to_sector align $PART_END)
      LOST_B_SIZE=$(echo "$LOST_B_SIZE + $REST" | bc -l)
    debug "oem Last sector="$(echo "$PART_END / $SECTOR_SIZE" | bc)
      
      create_part $DEVICE $PART_NB $PART_START $PART_END $PART_OEM_TYPE "oem"
    
      # Adjust partition size
      PART_OEM_SIZE=$(echo "$PART_END - $PART_START" | bc)
      DEVICE_FREE_SIZE=$(echo "$DEVICE_FREE_SIZE - $PART_OEM_SIZE - $SECTOR_SIZE" | bc)     # in bytes
      debug $FONT_CYAN$ATTR_UNDERLINED"DEVICE_FREE_SIZE= "$(echo "$DEVICE_FREE_SIZE $B_TO_MB" | bc)" MB"$ATTR_RESET
      echo -e $FONT_CYAN "END OF Partition /oem"$ATTR_RESET
    fi
    
    
## ------------------- Partition /data -------------------
    PART_NB=$(echo "$PART_NB + 1" | bc)
    PART_DATA_NB=$PART_NB
    PART_DATA_TYPE=ext4
    
    echo "LOST_B_SIZE="$LOST_B_SIZE
    
    LOST_B=$(echo "$LOST_B_SIZE $MB_TO_B" | bc)
    
    if [ ! -z $PART_IRS_SIZE ]; then
	PART_DATA_SIZE=$(echo "$DEVICE_FREE_SIZE - $PART_IRS_SIZE - 50 * $SECTOR_SIZE - $LOST_B_SIZE" | bc)
    else
	PART_DATA_SIZE=$(echo "$DEVICE_FREE_SIZE - 50 * $SECTOR_SIZE - $LOST_B_SIZE" | bc)
    fi
    
    PART_START=$(echo "$PART_END + $SECTOR_SIZE" | bc)
    PART_END=$(echo "$PART_START + $PART_DATA_SIZE" | bc)
    REST=$(align_to_sector lost $PART_END)
    debug "REST="$REST
    PART_END=$(align_to_sector align $PART_END)
    LOST_B_SIZE=$(echo "$LOST_B_SIZE + $REST" | bc -l)
    debug "data Last sector="$(echo "$PART_END / $SECTOR_SIZE" | bc)
   
    create_part $DEVICE $PART_NB $PART_START $PART_END $PART_DATA_TYPE "data"
    
    # Adjust partition size
    PART_DATA_SIZE=$(echo "$PART_END - $PART_START" | bc)
    DEVICE_FREE_SIZE=$(echo "$DEVICE_FREE_SIZE - $PART_DATA_SIZE - $SECTOR_SIZE" | bc)     # in bytes
    debug $FONT_CYAN$ATTR_UNDERLINED"DEVICE_FREE_SIZE= "$(echo "$DEVICE_FREE_SIZE $B_TO_MB" | bc)" MB"$ATTR_RESET
    echo -e $FONT_CYAN "END OF Partition /data"$ATTR_RESET
    

## ------------------- Partition INTEL Rapid Start -------------------
    if [ ! -z $PART_IRS_SIZE ]; then
	PART_NB=$(echo "$PART_NB + 1" | bc)
	PART_IRS_NB=$PART_NB
        PART_START=$(echo "$PART_END + $SECTOR_SIZE" | bc)
	PART_END=$(echo "$PART_START + $PART_IRS_SIZE - $SECTOR_SIZE" | bc)
        REST=$(align_to_sector lost $PART_END)
    debug "REST="$REST
        PART_END=$(align_to_sector align $PART_END)
        LOST_B_SIZE=$(echo "$LOST_B_SIZE + $REST" | bc -l)
    debug "irs Last sector="$(echo "$PART_END / $SECTOR_SIZE" | bc)
	
	create_part $DEVICE $PART_NB $PART_START $PART_END "ext4" "irs"
    
        # Adjust partition size
        PART_IRS_SIZE=$(echo "$PART_END - $PART_START" | bc)
	echo -e $FONT_RED"TODO TODO TODO TODO TODO TODO TODO "
	echo -e $FONT_BLUE"SET UUID: sudo tune2fs $DEVICE$PART_NB -U D3BFE2DE-3DAF-11DF-BA-40-E3A556D89593"$FONT_RED $ATTR_RESET
##	sudo tune2fs $DEVICE$PART_NB -U D3BFE2DE-3DAF-11DF-BA-40-E3A556D89593
	echo -e $FONT_RED"TODO TODO TODO TODO TODO TODO TODO "
	DEVICE_FREE_SIZE=$(echo "$DEVICE_FREE_SIZE - $PART_IRS_SIZE - - $SECTOR_SIZE" | bc)     # in bytes
	debug $FONT_CYAN$ATTR_UNDERLINED"DEVICE_FREE_SIZE= "$(echo "$DEVICE_FREE_SIZE $B_TO_MB" | bc)" MB"$ATTR_RESET
	echo -e $FONT_CYAN "END OF Partition INTEL Rapid Start"$ATTR_RESET
    fi
}

function install_with_dd {
    echo "sudo dd if="$1" of="$2" bs=1M"
    sudo dd if=$1 of=$2 bs=1M
}

function install_with_cp {
    folder_img="MOUNTED_"$(basename $1)
    folder_dev="MOUNTED_DEVICE"
    debug mkdir $folder_img
    mkdir $folder_img
    debug mkdir $folder_dev
    mkdir $folder_dev    
    debug sudo mount $1 $folder_img -t auto -o loop
    sudo mount $1 $folder_img -t auto -o loop
    debug sudo mount $2 $folder_dev -t auto -o loop
    sudo mount $2 $folder_dev -t auto -o loop
    
    debug cp -r $folder_img/* $folder_dev
    cp -r $folder_img/* $folder_dev
    
    debug sync
    sync
    debug sudo umount $folder_img
    sudo umount $folder_img
    debug sudo umount $folder_dev
    sudo umount $folder_dev
    debug rm -rf $folder_img
    rm -rf $folder_img
    debug rm -rf $folder_dev
    rm -rf $folder_dev
    
}

function install_img {

## ------------------- Partition UEFI boot/Recovery part1 & 2 -------------------
    if [ ! -z $PART_UEFIBOOT1_IMG_FILE ]; then
      install_with_cp $PART_UEFIBOOT1_IMG_FILE $DEVICE$PART_UEFIBOOT1_NB
      install_with_cp $PART_UEFIBOOT1_IMG_FILE $DEVICE$PART_UEFIBOOT2_NB
    fi
 
## ------------------- Partition /system -------------------
    if [ ! -z $PART_SYST_IMG_FILE ]; then
      install_with_cp $PART_SYST_IMG_FILE $DEVICE$PART_SYST_NB
    fi

## ------------------- Partition /oem -------------------
    if [ ! -z $PART_OEM_IMG_FILE ]; then
      install_with_cp $PART_OEM_IMG_FILE $DEVICE$PART_OEM_NB
    fi
    sync
}



function main {
    init $@
    
    if [ -z $DEVICE ]; then
      get_device
      DEFAULT=${DEVICE%%"\n"*}
      echo -e $FONT_BLUE"-----------------------\nDEVICES LIST=\n"$DEVICE"\n-----------------------\n"
#      echo -e $FONT_GREEN"DEFAULT="$DEFAULT$ATTR_RESET
      echo -e $FONT_BOLD$ATTR_UNDERLINED
      
      read -e -i $DEFAULT -p "Device? : "
      DEVICE=$REPLY
      echo -e $ATTR_RESET
    fi
    
    get_img_files
    
##    progress_bar&
    pb_pid=$!
    partitionning
    install_img
##    progress_bar_kill
 }

main $@
