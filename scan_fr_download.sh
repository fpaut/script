#!/bin/bash
NAME=$1
FIRST_CHAPTER=$2
END_CHAPTER=$3
START_PAGE=$4
ONLY_ONE=$5
PAGE_WITH_ERR=0

echo NAME=$NAME

# Chapter 1
# https://www.scan-fr.cc/uploads/manga/the-legend-of-zelda-twilight-princess/chapters/v1/001.jpg
# https://www.scan-fr.cc/uploads/manga/the-legend-of-zelda-twilight-princess/chapters/v1/1/001.jpg
# Chapter 13
# https://www.scan-fr.cc/uploads/manga/the-legend-of-zelda-twilight-princess/chapters/13/001.jpg

URL_BASE="https://www.scan-fr.cc/uploads/manga"


LOGFILE="$NAME"_CH"$CHAPTER"
log_err()
{
    txt="$@"
    echo $txt >> $LOGFILE
}

log()
{
    txt="$@"
    echo -e $txt > /dev/stderr
}

pad_number()
{
    number=$1
    maxPadLen=$2
	if [[ "${#number}" -ge "$maxPadLen" ]]; then
		echo $number
		return
	fi
#	echo "pad_number() number=$number" > /dev/stderr
	#Remove 0 avoiding octal interpretation and error "-bash: printf: 08: invalid octal number"
	OFF=0
	while [[ "${number:$OFF:1}" == "0" ]];
	do
		OFF=$(($OFF + 1))
	done
	number=${number:$OFF}
    fmt="%0"
    fmt+=$maxPadLen
    fmt+="d"
#	echo "pad_number() number=$number" > /dev/stderr
#	echo "pad_number() maxPadLen=$maxPadLen" > /dev/stderr
	if [[ "$maxPadLen" != "0" ]]; then
		printf "$fmt" $number
	else
		echo $number
	fi
}

update_url()
{
    NAME=$1
    CHAPTER=$2
    PAGE=$3
    log  "-n Get page $PAGE from $NAME, Chapter $CHAPTER: "

    UPDATED_URL="https://www.scan-fr.cc/uploads/manga/$NAME/chapters"
    case $NAME in
        the-legend-of-zelda-twilight-princess)
        ;;
        dragon-ball-super)
            UPDATED_URL=$URL_BASE/$NAME/chapters
            if [[ "$PAGE" -lt 10 ]]; then
				NUMBER=$(pad_number $PAGE 3)
                IMG="$NUMBER.jpg"
            else
                IMG=""$PAGE".jpg"
            fi
            case $CHAPTER in
                44)
                    UPDATED_URL=$UPDATED_URL/vf2/$CHAPTER                        
                ;;
                *)
                    UPDATED_URL=$UPDATED_URL/$CHAPTER
                ;;
            esac
        ;;     
        naruto)
            UPDATED_URL="$URL_BASE/$NAME/chapters/Volume $CHAPTER"
            IMG="$PAGE.jpg"
            if [[ "$CHAPTER" -lt 27 ]]; then
                IMG="$(pad_number $PAGE 3).jpg"
            fi
            if [[ "$CHAPTER" -ge 245 && "$CHAPTER" -lt 281 ]]; then
                IMG="$(pad_number $PAGE 2).jpg"
				UPDATED_URL="$URL_BASE/$NAME/chapters/$CHAPTER"
            fi
            if [[ "$CHAPTER" == 281 ]]; then
				if [[ "$PAGE" -lt 4 ]]; then
					IMG="$(pad_number $PAGE 2).jpg"
					UPDATED_URL="$URL_BASE/$NAME/chapters/$CHAPTER"
				else
					IMG="$(pad_number $PAGE 2).png"
					UPDATED_URL="$URL_BASE/$NAME/chapters/$CHAPTER"
				fi
            fi
            if [[ "$CHAPTER" -ge 359 && "$CHAPTER" -lt 701 ]]; then
				if [[ "$PAGE" -lt 4 ]]; then
					IMG="$(pad_number $PAGE 2).jpg"
					UPDATED_URL="$URL_BASE/$NAME/chapters/$CHAPTER"
				else
					IMG="$(pad_number $PAGE 2).png"
					UPDATED_URL="$URL_BASE/$NAME/chapters/$CHAPTER"
				fi
            fi
            if [[ "$CHAPTER" -ge 360 ]]; then
				IMG="$(pad_number $PAGE 2).jpg"
				UPDATED_URL="$URL_BASE/$NAME/chapters/$CHAPTER"
            fi
        ;;
        my-hero-academia)
            UPDATED_URL=$UPDATED_URL/$CHAPTER
       ;;
    esac
    UPDATED_URL="$UPDATED_URL;$IMG"
#    log "update_url($NAME,CH$CHAPTER, PAGE$PAGE) return $UPDATED_URL"
    echo $UPDATED_URL
}

get_chapter()
{
    NAME=$1
    CHAPTER=$2
    echo -ne $GREEN"Download Chapter $CHAPTER of $NAME"$ATTR_RESET; echo
    PAGE=$START_PAGE
    OUTPUT="./Manga/$NAME/Chapter_"$CHAPTER""
    WGET_ERR=0
    PAGE_WITH_ERR=0
    while [[ "$PAGE_WITH_ERR" -lt "3" ]]
    do
        if [[ "$PAGE" -lt 10 ]]; then
            IMG="0"$PAGE".jpg"
        else
            IMG=""$PAGE".jpg"
        fi
        URL=$(update_url $NAME $CHAPTER $PAGE)
        IMG=${URL#*;}
        URL=${URL%;*}

		WGET_OK=0
		NB_RETRY=0
		WGET_OPTS="" # "--retry-connrefused "
		WGET_OPTS+="--waitretry=0 "
		WGET_OPTS+="--read-timeout=3 "
		WGET_OPTS+="--timeout=3 "
		WGET_OPTS+="--tries 1 "
		WGET_OPTS+="--continue "
		while [[ "$WGET_OK" != "1" && NB_RETRY -lt 6 ]]
		do
			log  "-n ($URL/$IMG) :"
			CMD="wget $WGET_OPTS \"$URL/$IMG\""; UNUSED=$(eval "$CMD 2>&1 1>/dev/null"); WGET_ERR=$?
			if [[ "$WGET_ERR" != "0" ]]; then
				NB_RETRY=$(($NB_RETRY + 1))
				echo -e $RED" NOK, WGET_ERR=$WGET_ERR NB_RETRY=$NB_RETRY PAGE_WITH_ERR=$PAGE_WITH_ERR"$ATTR_RESET
				if [[ "$NB_RETRY" == "3" ]]; then
					IMG=$(echo $IMG |  sed "s,jpg,png,g")
				fi
			else
				PAGE_WITH_ERR=0
				NB_RETRY=0
				WGET_OK=1
				echo -e $GREEN" OK on RETRY=$NB_RETRY"$ATTR_RESET
			fi
		done
		if [[ "$WGET_ERR" != "0" ]]; then
			PAGE_WITH_ERR=$(($PAGE_WITH_ERR + 1))
		else
			PAGE_WITH_ERR=0
		fi
        if ! [[ -e $OUTPUT ]]; then
            echo -ne $GREEN"Create Folder $OUTPUT"$ATTR_RESET; echo
            mkdir -p $OUTPUT
        fi
            mkdir -p $OUTPUT
            
            
        CMD="mv -vf ./$IMG $OUTPUT"; $CMD; ERR=$?
        PAGE=$(($PAGE + 1))
    done
}

convert_to_pdf()
{
    NAME=$1
    CHAPTER=$2
    OUTPUT="./Manga/$NAME/Chapter_"$CHAPTER""
    echo -ne $CYAN"Convert $NAME Chapter $CHAPTER to PDF"$ATTR_RESET
    OUTPUT="./Manga/$NAME/Chapter_"$CHAPTER""
    
    cd $OUTPUT
    img_to_pdf.sh "*" "$NAME-Chapitre_$(printf %03d $CHAPTER)".pdf
    echo -ne $GREEN"Move  $OUTPUT/$NAME-Chapitre_$(printf %03d $CHAPTER) to $OUTPUT/.."$ATTR_RESET; echo
    cd -
    echo "mv $OUTPUT/"$NAME-Chapitre_$(printf %03d $CHAPTER)".pdf $OUTPUT/.."; echo
    mv $OUTPUT/"$NAME-Chapitre_$(printf %03d $CHAPTER)".pdf $OUTPUT/..
###    echo -ne $GREEN"Delete $OUTPUT"$ATTR_RESET; echo
###    rm -vrf $OUTPUT 2>/dev/null
}

CHAPTER=$FIRST_CHAPTER
echo -e $CYAN"Ready to download from $URL_BASE"$ATTR_RESET
while [[ "$CHAPTER" -le $END_CHAPTER ]]
do
    get_chapter $NAME $CHAPTER
    convert_to_pdf $NAME $CHAPTER
    if [[ "$ONLY_ONE" != "" || "$CHAPTER" -ge $END_CHAPTER ]]; then
        CHAPTER=$END_CHAPTER
    fi
    CHAPTER=$(($CHAPTER+ 1))
done


echo; echo; echo
CMD="ls -halF ./Manga/$NAME"
echo -ne $CYAN
echo $CMD; $CMD
echo -e $ATTR_RESET
