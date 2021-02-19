#!/bin/bash
NAME=$1
FIRST_CHAPTER=$2
END_CHAPTER=$3
START_PAGE=$4
ONLY_ONE=$5
PAGE_WITH_ERR=0

# Chapter 1
# https://www.scan-fr.cc/uploads/manga/the-legend-of-zelda-twilight-princess/chapters/v1/001.jpg
# https://www.scan-fr.cc/uploads/manga/the-legend-of-zelda-twilight-princess/chapters/v1/1/001.jpg
# Chapter 13
# https://www.scan-fr.cc/uploads/manga/the-legend-of-zelda-twilight-princess/chapters/13/001.jpg

URL_BASE="https://www.scan-fr.cc/uploads/manga"

OUTPUT="./Manga/$NAME"
log_err()
{
    txt="$@"
    echo $txt >> $LOGFILE
}

log()
{
    txt="$@"
    echo -e $txt$ATTR_RESET > /dev/stderr
}

pad_number()
{
    number=$1
    maxPadLen=$2
	if [[ "${#number}" -ge "$maxPadLen" ]]; then
		echo $number
		return
	fi
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
    IMG_EXT=$4
    log  "-n Get page $PAGE from $NAME, Chapitre $CHAPTER: "
    log_err  "-n Get page $PAGE from $NAME, Chapitre $CHAPTER: "

    UPDATED_URL="https://www.scan-fr.cc/uploads/manga/$NAME/chapters"
    case $NAME in
        the-legend-of-zelda-twilight-princess)
        ;;
        dragon-ball-super)
            UPDATED_URL=$URL_BASE/$NAME/chapters
            if [[ "$PAGE" -lt 10 ]]; then
				NUMBER=$(pad_number $PAGE 3)
                IMG="$NUMBER.$IMG_EXT"
            else
                IMG=""$PAGE".$IMG_EXT"
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
            IMG="$PAGE.$IMG_EXT"
            if [[ "$CHAPTER" -lt 27 ]]; then
                IMG="$(pad_number $PAGE 3).$IMG_EXT"
            fi
            if [[ "$CHAPTER" -ge 245 && "$CHAPTER" -lt 281 ]]; then
			    log "Line 91"
                IMG="$(pad_number $PAGE 2).$IMG_EXT"
				UPDATED_URL="$URL_BASE/$NAME/chapters/$CHAPTER"
            fi
            if [[ "$CHAPTER" == 281 ]]; then
				if [[ "$PAGE" -lt 4 ]]; then
					IMG="$(pad_number $PAGE 2).$IMG_EXT"
					UPDATED_URL="$URL_BASE/$NAME/chapters/$CHAPTER"
				else
					IMG="$(pad_number $PAGE 2).$IMG_EXT"
					UPDATED_URL="$URL_BASE/$NAME/chapters/$CHAPTER"
				fi
            fi
            if [[ "$CHAPTER" -ge 282 ]]; then
				IMG="$(pad_number $PAGE 2).$IMG_EXT"
				UPDATED_URL="$URL_BASE/$NAME/chapters/""$CHAPTER"
             fi
        ;;
       my-hero-academia)
            UPDATED_URL=$UPDATED_URL/$CHAPTER
       ;;
	   *)
			log "Default case for NAME=$NAME"
	   ;;
    esac
    UPDATED_URL="$UPDATED_URL;$IMG"
    log "update_url($NAME,CH$CHAPTER, PAGE$PAGE) return $UPDATED_URL"
    echo $UPDATED_URL
}

get_chapter()
{
    NAME=$1
    CHAPTER=$2
	LOGFILE="$OUTPUT/$NAME"_CH"$CHAPTER".log
	IMG_EXT="png"
	rm -vRf $LOGFILE
    log -n $GREEN"Download Chapitre $CHAPTER of $NAME"; echo
    PAGE=$START_PAGE
    DOWNLOAD_FOLDER="$OUTPUT/Chapitre_"$CHAPTER
	log DOWNLOAD_FOLDER=$DOWNLOAD_FOLDER
    WGET_ERR=0
    PAGE_WITH_ERR=0
	rm -rf $DOWNLOAD_FOLDER
    while [[ "$PAGE_WITH_ERR" -lt "3" ]]
    do
        if [[ "$PAGE" -lt 10 ]]; then
            IMG="0"$PAGE".$IMG_EXT"
        else
            IMG=""$PAGE".$IMG_EXT"
        fi
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
			URL=$(update_url $NAME $CHAPTER $PAGE $IMG_EXT)
			IMG=${URL#*;}
			URL=${URL%;*}
			log  "-n ($URL/$IMG) :"
			CMD="wget $WGET_OPTS \"$URL/$IMG\""; UNUSED=$(eval "$CMD 2>&1 1>/dev/null"); WGET_ERR=$?
			if [[ "$WGET_ERR" != "0" ]]; then
				NB_RETRY=$(($NB_RETRY + 1))
				log $RED" NOK, WGET_ERR=$WGET_ERR NB_RETRY=$NB_RETRY PAGE_WITH_ERR=$PAGE_WITH_ERR"
				if [[ "$NB_RETRY" == "3" ]]; then
					if [[ "$IMG_EXT" == "png" ]]; then
						IMG_EXT="jpg"
					else
						IMG_EXT="png"
					fi
				fi
			else
				PAGE_WITH_ERR=0
				NB_RETRY=0
				WGET_OK=1
				log $GREEN" OK on RETRY=$NB_RETRY"
				log_err " OK on RETRY=$NB_RETRY"
			fi
		done
		if [[ "$NB_RETRY" -ge 6 ]]; then
				log_err "Error on $NAME / Ch $CHAPTER / PAGE $PAGE"
		fi
		if [[ "$WGET_ERR" != "0" ]]; then
			PAGE_WITH_ERR=$(($PAGE_WITH_ERR + 1))
		else
			PAGE_WITH_ERR=0
		fi
        if ! [[ -e $DOWNLOAD_FOLDER ]]; then
            log -n $GREEN"Create Folder $DOWNLOAD_FOLDER"; echo
            mkdir -p $DOWNLOAD_FOLDER
        fi
            mkdir -p $DOWNLOAD_FOLDER
            
            
        CMD="mv -vf ./$IMG $DOWNLOAD_FOLDER"; $CMD; ERR=$?
        PAGE=$(($PAGE + 1))
    done
	log_err "Too many error on $NAME / Ch $CHAPTER"
}

convert_to_pdf()
{
    NAME=$1
    CHAPTER=$2
    PDF_OUTPUT="$OUTPUT/Chapitre_"$CHAPTER""
    log -n $CYAN"Convert $NAME Chapitre $CHAPTER to PDF"
    
    cd $PDF_OUTPUT
    img_to_pdf.sh "*" "$NAME-Chapitre_$(printf %03d $CHAPTER)".pdf
    echo -ne $GREEN"Move  $PDF_OUTPUT/$NAME-Chapitre_$(printf %03d $CHAPTER) to $PDF_OUTPUT/.."; echo
    cd -
    log "mv $PDF_OUTPUT/"$NAME-Chapitre_$(printf %03d $CHAPTER)".pdf $PDF_OUTPUT/.."; echo
    mv $PDF_OUTPUT/"$NAME-Chapitre_$(printf %03d $CHAPTER)".pdf $PDF_OUTPUT/..
}

CHAPTER=$FIRST_CHAPTER
log $CYAN"Ready to download from $URL_BASE"
rm -f $LOGFILE
while [[ "$CHAPTER" -le $END_CHAPTER ]]
do
    get_chapter $NAME $CHAPTER
    convert_to_pdf $NAME $CHAPTER
    if [[ "$ONLY_ONE" != "" || "$CHAPTER" -ge $END_CHAPTER ]]; then
        CHAPTER=$END_CHAPTER
    fi
    CHAPTER=$(($CHAPTER+ 1))
done
log_err "End chapter ($END_CHAPTER) reached!"
log	"Logfile is $LOGFILE :"
cat $LOGFILE
echo; echo; echo
CMD="ls -halF $OUTPUT"
log -ne $CYAN$CMD; $CMD
