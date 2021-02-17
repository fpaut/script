#!/bin/bash
NAME=$1
FIRST_CHAPTER=$2
END_CHAPTER=$3
ONLY_ONE=$4
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

img_type()
{
    ext=$1
    format=$2
    page=$3
    fmt="%0"
    fmt+=$format
    fmt+="d.$ext"
    echo $fmt> /dev/stderr
    
#    printf $fmt $page -e $txt > /dev/stdout
}

update_url()
{
    NAME=$1
    CHAPTER=$2
    PAGE=$3
    log  "-n Get page $PAGE from $NAME, Chapter $CHAPTER: "
    log_err  "Get page $PAGE from $NAME, Chapter $CHAPTER: "

    UPDATED_URL="https://www.scan-fr.cc/uploads/manga/$NAME/chapters"
    case $NAME in
        the-legend-of-zelda-twilight-princess)
        ;;
        dragon-ball-super)
            UPDATED_URL=$URL_BASE/$NAME/chapters
            if [[ "$PAGE" -lt 10 ]]; then
                IMG="0"$PAGE".jpg"
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
            IMG=$PAGE".jpg"
            if [[ "$CHAPTER" -lt 28 ]]; then
                if [[ "$PAGE" -lt 10 ]]; then
                    IMG=$(img_type jpg 3 $PAGE)
                fi
                
                if [[ "$PAGE" -ge 10 && "$PAGE" -lt 27 ]]; then
                    IMG=$(img_type jpg 2 $PAGE)
                fi    
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
    echo -e $GREEN"Download "
    echo -e $GREEN"NAME=$NAME"
    echo -e $GREEN"CHAPTER=$CHAPTER"$ATTR_RESET; echo
    PAGE=0
    OUTPUT="/home/user/Documents/Doc_Perso/Fred/ebook/Manga/$NAME/Chapter_"$CHAPTER""
    ERR=0
    PAGE_WITH_ERR=0
    while [[ "$PAGE_WITH_ERR" -lt "5" ]]
    do
        if [[ "$PAGE" -lt 10 ]]; then
            IMG="0"$PAGE".jpg"
        else
            IMG=""$PAGE".jpg"
        fi
        URL=$(update_url $NAME $CHAPTER $PAGE)
        IMG=${URL#*;}
        URL=${URL%;*}

        CMD="wget \"$URL/$IMG\""; UNUSED=$(eval "$CMD 2>&1 1>/dev/null"); ERR=$?
        if [[ "$ERR" != "0" ]]; then
            PAGE_WITH_ERR=$(($PAGE_WITH_ERR + 1))
            echo -e $RED"NOK, ERR=$ERR PAGE_WITH_ERR=$PAGE_WITH_ERR"$ATTR_RESET
            log_err  "Get page $PAGE from $NAME, Chapter $CHAPTER: "
            log_err  \"$URL/$IMG\
        else
            PAGE_WITH_ERR=0
            echo -e $GREEN"OK"$ATTR_RESET
        fi
        if ! [[ -e $OUTPUT ]]; then
            echo -ne $GREEN"Create Folder $OUTPUT"$ATTR_RESET; echo
            mkdir -p $OUTPUT
        fi
            mkdir -p $OUTPUT
            
            
        CMD="mv -vf ./$IMG $OUTPUT"; $CMD; ERR=$?
        PAGE=$(($PAGE + 1))
    done
    if [[ "$PAGE" -ge "5" ]]; then
        CHAPTER_WITH_ERR=$(($CHAPTER_WITH_ERR + 1))
    fi
}

convert_to_pdf()
{
    NAME=$1
    CHAPTER=$2
    OUTPUT="/home/user/Documents/Doc_Perso/Fred/ebook/Manga/$NAME/Chapter_"$CHAPTER""
    echo -ne $CYAN"Convert $NAME Chapter $CHAPTER to PDF"$ATTR_RESET
    OUTPUT="/home/user/Documents/Doc_Perso/Fred/ebook/Manga/$NAME/Chapter_"$CHAPTER""
    
    cd $OUTPUT
    img_to_pdf.sh "*" "$NAME-Chapter_$(printf %03d $CHAPTER)".pdf
    echo -ne $GREEN"Move  $OUTPUT/* to $OUTPUT/.."$ATTR_RESET; echo
    mv $OUTPUT/"$NAME-Chaptitre_$(printf %03d $CHAPTER)".pdf $OUTPUT/.. 2>/dev/null
###    echo -ne $GREEN"Delete $OUTPUT"$ATTR_RESET; echo
###    rm -vrf $OUTPUT 2>/dev/null
}

CHAPTER=$FIRST_CHAPTER
echo -e $CYAN"Ready to download from $URL_BASE"$ATTR_RESET
rm -f $LOGFILE
CHAPTER_WITH_ERR=0
while [[ "$CHAPTER" -le $END_CHAPTER && "$CHAPTER_WITH_ERR" -lt 2 ]]
do
    get_chapter $NAME $CHAPTER
    convert_to_pdf $NAME $CHAPTER
   if [[ "$ONLY_ONE" != "" || "$CHAPTER" -ge $END_CHAPTER ]]; then
        CHAPTER=$END_CHAPTER
    fi
    CHAPTER=$(($CHAPTER+ 1))
done


echo; echo; echo
CMD="ls -halF /home/user/Documents/Doc_Perso/Fred/ebook/Manga/$NAME"
echo -ne $CYAN
echo $CMD; $CMD
echo -e $ATTR_RESET
