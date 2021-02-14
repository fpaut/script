#!/bin/bash
NAME=$1
FIRST_CHAPTER=$2
END_CHAPTER=$3
ONLY_ONE=$4

echo NAME=$NAME

# Chapter 1
# https://www.scan-fr.cc/uploads/manga/the-legend-of-zelda-twilight-princess/chapters/v1/001.jpg
# https://www.scan-fr.cc/uploads/manga/the-legend-of-zelda-twilight-princess/chapters/v1/1/001.jpg
# Chapter 13
# https://www.scan-fr.cc/uploads/manga/the-legend-of-zelda-twilight-princess/chapters/13/001.jpg

URL_BASE="https://www.scan-fr.cc/uploads/manga"
update_url()
{
    NAME=$1
    CHAPTER=$2
    PAGE=$3
    echo  "update_url   NAME=$NAME CHAPTER=$CHAPTER PAGE=$PAGE" > /dev/stderr

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
        my-hero-academia)
            UPDATED_URL=$UPDATED_URL/$CHAPTER
       ;;
    esac
    UPDATED_URL="$UPDATED_URL;$IMG"
    echo "$UPDATED_URL" > /dev/stderr
    echo $UPDATED_URL
}

get_chapter()
{
    NAME=$1
    CHAPTER=$2
    echo -ne $GREEN"Download Chapter $CHAPTER of $NAME"$ATTR_RESET; echo
    PAGE=1
    OUTPUT="/home/user/Documents/Doc_Perso/Fred/ebook/Manga/$NAME/Chapter_"$CHAPTER""
    ERR=0
    while [[ "$ERR" == "0" ]]
    do
        if [[ "$PAGE" -lt 10 ]]; then
            IMG="0"$PAGE".jpg"
        else
            IMG=""$PAGE".jpg"
        fi
        URL=$(update_url $NAME $CHAPTER $PAGE)
        IMG=${URL#*;}
        URL=${URL%;*}
        
        
    #    echo IMG=$IMG URL=$URL; exit

        
        
        
        CMD="wget $URL/$IMG"; echo $CMD; UNUSED=$($CMD); ERR=$?
#        HTTRACK_FILTER="+*.png +**.jpg +**.jpeg  -*x*"
#       CMD="httrack $URL $HTTRACK_FILTER -O $OUTPUT --file-log $OUTPUT/$NAME-$CHAPITRE.log"; echo $CMD; eval "$CMD"
       if [[ "$ERR" != "0" ]]; then
            echo -ne $RED"WGET return $ERR"$ATTR_RESET; echo
            return
        fi
        if ! [[ -e $OUTPUT ]]; then
            echo -ne $GREEN"Create Folder $OUTPUT"$ATTR_RESET; echo
            mkdir -p $OUTPUT
        fi
            mkdir -p $OUTPUT
            
            
        CMD="mv -f ./$IMG $OUTPUT"; echo $CMD; $CMD; ERR=$?
        PAGE=$(($PAGE + 1))
    done
}

convert_to_pdf()
{
    NAME=$1
    CHAPTER=$2
    OUTPUT="/home/user/Documents/Doc_Perso/Fred/ebook/Manga/$NAME/Chapter_"$CHAPTER""
    echo -ne $CYAN"Convert $NAME Chapter $CHAPTER to PDF"$ATTR_RESET
    OUTPUT="/home/user/Documents/Doc_Perso/Fred/ebook/Manga/$NAME/Chapter_"$CHAPTER""
    
    cd $OUTPUT
    img_to_pdf.sh "*" "$NAME-Chapter_$CHAPTER".pdf
    echo -ne $GREEN"Move  $OUTPUT/* to $OUTPUT/.."$ATTR_RESET; echo
    mv $OUTPUT/* $OUTPUT/.. 2>/dev/null
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

CHAPTER=$FIRST_CHAPTER
echo Before Convert
echo CHAPTER=$CHAPTER
while [[ "$CHAPTER" -le $END_CHAPTER ]]
do
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
