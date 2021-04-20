#!/bin/bash
source ~/bin/scripts/.bash_tools.sh
source ~/bin/scripts/.bashrc_aliases.sh
NAME=$1
FIRST_CHAPTER=$2
END_CHAPTER=$3
FIRST_PAGE=$4
PAGE_WITH_ERR=0

# Chapitre  1
# https://www.scan-fr.cc/uploads/manga/the-legend-of-zelda-twilight-princess/chapters/v1/001.jpg
# https://www.scan-fr.cc/uploads/manga/the-legend-of-zelda-twilight-princess/chapters/v1/1/001.jpg
# Chapitre  13
# https://www.scan-fr.cc/uploads/manga/the-legend-of-zelda-twilight-princess/chapters/13/001.jpg


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
    if [[ "$format" != "0" ]]; then
        fmt="%0"
        fmt+=$format
    else
        fmt="%"
    fi
    fmt+="d.$ext"
#    echo $fmt> /dev/stderr
    
    printf $fmt $page > /dev/stdout
}

update_url()
{
    NAME=$1
    CHAPTER=$2
    PAGE=$3

    URL_BASE="https://www.scan-fr.cc/uploads/manga"
    UPDATED_URL="$URL_BASE/$NAME/chapters"
                echo UPDATED_URL=$UPDATED_URL >/dev/stderr
    case $NAME in
        shingeki-no-kyojin)
            UPDATED_URL+="/$CHAPTER"
            IMG=$(img_type jpg 2 $PAGE)
            if [[ "$CHAPTER" == 133 ]]; then
                UPDATED_URL+="/vf"
            fi
#            if [[ "$CHAPTER" -ge 100 && "$CHAPTER" -lt 101 ]]; then
            if [[ $(between $CHAPTER 100 101) ]]; then
                IMG=$(img_type jpeg 2 $PAGE)
                UPDATED_URL+="/$CHAPTER"
            fi
            if [[ "$CHAPTER" -ge 101 && "$CHAPTER" -lt 102 ]]; then
                IMG=mmd-page-$(img_type jpg 3 $PAGE)
            fi            
            if [[ "$CHAPTER" -ge 102 && "$CHAPTER" -lt 104 ]]; then
                IMG=$(img_type jpg 0 $PAGE)
            fi            
            if [[ "$CHAPTER" -ge 133 && "$CHAPTER" -lt 134 ]]; then
                IMG=$(img_type jpg 0 $PAGE)
            fi
            if [[ "$CHAPTER" -ge 135 && "$CHAPTER" -lt 138 ]]; then
#                 UPDATED_URL+="/vf"
                IMG=$(img_type jpg 3 $PAGE)
            fi
            if [[ "$CHAPTER" -ge 138 && "$CHAPTER" -lt 139 ]]; then
                UPDATED_URL+="/vf2"
                IMG=$(img_type jpg 3 $PAGE)
            fi
            if [[ "$CHAPTER" -ge 104 && "$CHAPTER" -lt 105 ]]; then
                IMG=$(img_type jpg 0 $PAGE)
            fi
            if [[ "$CHAPTER" -ge 105 && "$CHAPTER" -lt 131 ]]; then
                IMG=$(img_type jpeg 0 $PAGE)
            fi
            if [[ "$CHAPTER" -ge 106 && "$CHAPTER" -lt 131 ]]; then
                IMG=$(img_type jpg 0 $PAGE)
            fi
            if [[ "$CHAPTER" -ge 109 && "$CHAPTER" -lt 117 ]]; then
                IMG="/img"$(img_type jpg 0 $PAGE)
             fi
            if [[ "$CHAPTER" -ge 117 && "$CHAPTER" -lt 118 ]]; then
                UPDATED_URL+="/vf"
                IMG="/img"$(img_type jpg 0 $PAGE)
             fi
            if [[ "$CHAPTER" -ge 118 && "$CHAPTER" -lt 131 ]]; then
                IMG=$(img_type jpeg 0 $PAGE)
             fi
            if [[ "$CHAPTER" -ge 119 && "$CHAPTER" -lt 131 ]]; then
                IMG=$(img_type jpg 0 $PAGE)
             fi
            if [[ "$CHAPTER" -ge 129 && "$CHAPTER" -lt 130 ]]; then
                IMG=$(img_type jpeg 0 $PAGE)
             fi
            if [[ "$CHAPTER" -ge 130 && "$CHAPTER" -lt 131 ]]; then
                IMG=$(img_type jpg 0 $PAGE)
             fi
            if [[ "$CHAPTER" -ge 131 && "$CHAPTER" -lt 140 ]]; then
                IMG=$(img_type jpg 0 $PAGE)
             fi
            if [[ "$CHAPTER" -ge 139 ]]; then
                UPDATED_URL+="/vf"
                IMG=$(img_type jpg 0 $PAGE)
            fi
       ;;
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
 #   log_debug "update_url($NAME,CH$CHAPTER, PAGE$PAGE) return $UPDATED_URL"
    echo $UPDATED_URL
}

get_chapter()
{
    NAME=$1
    CHAPTER=$2
    log  "Chapitre $CHAPTER de $NAME"
    log_err  "Chapitre $CHAPTER de $NAME"
    echo -e $GREEN"Download "
    echo -e $GREEN"NAME=$NAME"
    echo -e $GREEN"CHAPTER=$CHAPTER"$ATTR_RESET; echo
    PAGE=$FIRST_PAGE
    OUTPUT="/home/user/Documents/Doc_Perso/Fred/ebook/Manga/$NAME/Chapitre_"$CHAPTER""
    ERR=0
    PAGE_WITH_ERR=0
    MAX_ERRORS=10
    while [[ "$PAGE_WITH_ERR" -lt "$MAX_ERRORS" ]]
    do
        if [[ "$PAGE" -lt 10 ]]; then
            IMG="0"$PAGE".jpg"
        else
            IMG=""$PAGE".jpg"
        fi
        URL=$(update_url $NAME $CHAPTER $PAGE)
        IMG=${URL#*;}
        URL=${URL%;*}
        
        log  "-n $NAME / Chapitre $CHAPTER / Page $PAGE"
        log_err  "-n $NAME / Chapitre $CHAPTER / Page $PAGE"
        

        CMD="wget \"$URL/$IMG\""; log_debug "-n : $CMD"; UNUSED=$(eval "$CMD 2>&1 1>/dev/null"); ERR=$?
        if [[ "$ERR" != "0" ]]; then
            PAGE_WITH_ERR=$(($PAGE_WITH_ERR + 1))
            log $RED" : NOK, erreurs $PAGE_WITH_ERR/$MAX_ERRORS (ERR=$ERR)"$ATTR_RESET
        else
            PAGE_WITH_ERR=0
            CHAPTER_WITH_ERR=0
            log $GREEN" : OK"$ATTR_RESET
        fi
        if ! [[ -e $OUTPUT ]]; then
            echo -ne $GREEN"Create Folder $OUTPUT"$ATTR_RESET; echo
            mkdir -p $OUTPUT
        fi
            mkdir -p $OUTPUT
            
        if [[ -e ./$IMG ]]; then
            CMD="mv -f ./$IMG $OUTPUT"; $CMD; ERR=$?
        fi
        PAGE=$(($PAGE + 1))
    done
    if [[ "$PAGE_WITH_ERR" -ge "$MAX_ERRORS" ]]; then
        CHAPTER_WITH_ERR=$(($CHAPTER_WITH_ERR + 1))
    fi
}

convert_to_pdf()
{
    NAME=$1
    CHAPTER=$2
    OUTPUT="/home/user/Documents/Doc_Perso/Fred/ebook/Manga/$NAME/Chapitre_"$CHAPTER""
    echo -ne $CYAN"Conversion de $NAME Chapitre $CHAPTER en PDF"$ATTR_RESET
    
    cd $OUTPUT
    img_to_pdf.sh "*" "$NAME-Chapitre_$(printf %03d $CHAPTER)".pdf
    SRC="$OUTPUT/"$NAME-Chapitre_$(printf %03d $CHAPTER)".pdf"
    DEST="$OUTPUT/.."
    log_debug $GREEN"Move  $SRC to $DEST"$ATTR_RESET; echo
    mv $SRC $DEST 2>/dev/null
    if [[ "$?" == "0" ]]; then
        echo -ne $GREEN"Delete $OUTPUT"$ATTR_RESET; echo
        rm -vrf $OUTPUT 2>/dev/null
    fi
}

CHAPTER=$FIRST_CHAPTER
LOGFILE="$NAME"_CH"$CHAPTER".log
if [[ "$CHAPTER" -ge $END_CHAPTER ]]; then
    log $CYAN"Téléchargement du chapitre $FIRST_CHAPTER de $NAME"$ATTR_RESET
else
    log $CYAN"Téléchargement de $NAME du chapitre $FIRST_CHAPTER à $END_CHAPTER"$ATTR_RESET
fi
sleep 2


log_debug "LOGFILE is "$LOGFILE
rm -f $LOGFILE
CHAPTER_WITH_ERR=0
while [[ "$CHAPTER" -le $END_CHAPTER && "$CHAPTER_WITH_ERR" -lt 2 ]]
do
    get_chapter $NAME $CHAPTER
    convert_to_pdf $NAME $CHAPTER
    log_debug CHAPTER=$CHAPTER
    log_debug END_CHAPTER=$END_CHAPTER
    log_debug CHAPTER_WITH_ERR=$CHAPTER_WITH_ERR
    if [[ "$CHAPTER" -ge $END_CHAPTER ]]; then
        CHAPTER=$END_CHAPTER
        log $GREEN"Fini!"$ATTR_RESET
        log_err $GREEN"Fini!"$ATTR_RESET
    fi
    CHAPTER=$(($CHAPTER+ 1))
done


echo; echo; echo
CHAPTER=$FIRST_CHAPTER
while [[ "$CHAPTER" -le $END_CHAPTER ]]
do
    CMD="ls -halF /home/user/Documents/Doc_Perso/Fred/ebook/Manga/$NAME/"$NAME-Chapitre_$(printf %03d $CHAPTER)".pdf"
    if [[ -e "/home/user/Documents/Doc_Perso/Fred/ebook/Manga/$NAME/"$NAME-Chapitre_$(printf %03d $CHAPTER)".pdf" ]]; then
        echo -ne $CYAN
        echo $CMD; $CMD
        echo -e $ATTR_RESET
    fi
    CHAPTER=$(($CHAPTER + 1))
done
echo
