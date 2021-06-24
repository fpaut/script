#!/bin/bash
source ~/bin/scripts/.bash_tools.sh
source ~/bin/scripts/.bashrc_aliases.sh
source ~/bin/scripts/img_to_pdf.sh
manga_name=$1
first_chapter=$2
end_chapter=$3
FIRST_PAGE=$4
PAGE_WITH_ERR=0
tmp_folder="$HOME/tmp"
export LOGFILE="$tmp_folder/$manga_name.log"
export file_nb_digits=13

WEBSITE_URL="https://www.japanread.cc/manga"
USER_AGENT="\"Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1)\""
set +x

[[ "$first_chapter" == "" ]] && first_chapter=1
[[ "$end_chapter" == "" ]] && end_chapter=99999

# Chapitre  1
# https://www.scan-fr.cc/uploads/manga/the-legend-of-zelda-twilight-princess/chapters/v1/001.jpg
# https://www.scan-fr.cc/uploads/manga/the-legend-of-zelda-twilight-princess/chapters/v1/1/001.jpg
# Chapitre  13
# https://www.scan-fr.cc/uploads/manga/the-legend-of-zelda-twilight-princess/chapters/13/001.jpg

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

get_html_chapter_list()
{
    name="$1"
    debug_log "get_html_chapter_list($name)"
    url="$WEBSITE_URL/$name"
    output="$tmp_folder/$name.html"
    if [[ ! -e $output || $(file_get_size "$output") -le "1" ]]; then
        debug_log "wget -U $USER_AGENT $url -O \"$output\""
        wget -U $USER_AGENT $url -O "$output"
        logfile "$url downloaded in $output"
    else
        logfile "$output already exist!"
    fi
    cat "$output"
}

extract_chapter_list()
{
    name="$1"
    html_content="$2"
    FILTER1="manga/$name/"
    FILTER2="href"
    EXCLUDE="comments"
    echo -e "$html_content" | grep --color=never -i "$FILTER1" | grep --color=never "$FILTER2" | grep -v --color=never "$EXCLUDE" | tac | while read url
    do
        chapt=${url##*$name/}
        echo ${chapt%%\"*}
    done
    nb_ch=$(echo -e "$html_content" | grep --color=never -i "$FILTER1" | grep --color=never "$FILTER2" | grep -v --color=never "$EXCLUDE" | wc -l)
    logfile "$nb_ch chapters found"
}

get_html_page_list()
{
    name="$1"
    chapter="$2"
    debug_log "get_html_page_list($name, chapt $chapter)"
    url="https://www.scan-fr.cc/manga/$name/$chapter/1"
    output="$tmp_folder/$name"_"$chapter.html"
    if [[ ! -e $output || $(file_get_size "$output") -le "1" ]]; then
        debug_log "wget  -U $USER_AGENT $url -O \"$output\""
        CMD="wget  -U $USER_AGENT \"$url\" -O $output"; UNUSED=$(eval "$CMD 2>&1 1>/dev/null"); ERR=$?
       logfile "$url downloaded in $output"
    else
        logfile "$output already exist!"
    fi
    sed 's/[^[:print:]]//g' $output
    cat "$output"
}

extract_page_url_list()
{
    html_content="$1"
    logfile "get pages list..."
    debug_log "extract_page_url_list()"
    echo -e "$html_content" | grep --color=never "Page" | grep --color=never "data-src" | while read line
    do
        line=${line#*data-src=\' }
        line=${line% \'*}
        echo $line
    done
    nb_page=$(echo -e "$html_content" | grep --color=never "Page" | grep --color=never "data-src" | wc -l)
    logfile "$nb_page pages found"
}



get_chapter()
{
    name="$1"
    chapter="$2"
    page_url_list="$3"
    logfile "=================================================="
    logfile "Downloading $name, chapter $chapter"
    nb_page=${#page_url_list[@]}
    page_count=0
     for page_url in ${page_url_list[@]}
    do
        page_count=$(($page_count  + 1))
        file=$(basename "$page_url")
        logscreen_only $page_count/$nb_page \"$file\"
        logfile_only $file
        output="./$name/Chapitre_""$chapter"
        if [[ ! -e "$output" ]]; then
            mkdir -p $output
        fi
        output+="/$file"
        padded_name="./$name/Chapitre_""$chapter"
        filename=$(file_get_name $file)
        ext=$(file_get_ext $file)
        padded_name+=/$(str_pad_left $filename 15 0).$ext
        if [[ ! -e "$output" && ! -e "$padded_name" ]]; then
            CMD="wget  -U $USER_AGENT \"$page_url\" -O $output"
			debug_log $CMD
            UNUSED=$(eval "$CMD 2>&1 1>/dev/null"); 
            ERR=$?
        else
            logfile_only ": already exist!"
            ERR=0
        fi
        [[ "$ERR" == "0" ]] && logfile_only ": OK"
        [[ "$ERR" != "0" ]] && logfile_only ": NOK"
    done
}

convert_to_pdf()
{
    manga_name=$1
    chapter=$2
    src_folder="/home/user/Documents/Doc_Perso/Fred/ebook/Manga/$manga_name/Chapitre_"$chapter""
    
    logfile "Convert $manga_name Chapter $chapter in PDF format"
    debug_log Cleaning all old pdf
    cleaning_all_pdf "$src_folder"
    debug_log normalize_filename
    normalize_filename "$src_folder" $file_nb_digits "jpg|jpeg|png"
    debug_log convert each image as pdf
    convert_img_as_pdf "$src_folder" "jpg|jpeg|png"
    debug_log concatenate all generated pdfs
    create_final_pdf "$src_folder" "/home/user/Documents/Doc_Perso/Fred/ebook/Manga/$manga_name/$manga_name-Chapitre_$(printf %04d $chapter).pdf"
    if [[ "$?" == "0" ]]; then
        echo -ne $GREEN"Delete $src_folder"; echo
        #rm -vrf $src_folder 2>/dev/null
    fi
}

chapter=$first_chapter
[[ -e $LOGFILE ]] && rm -f $LOGFILE
chapter_WITH_ERR=0

# Pour chaque manga, recuperation du fichier html contenant tout les chapitres
html_chapter_list=$(get_html_chapter_list $manga_name)
# Pour chaque manga, recuperation de la liste de numero de chapitre
chapter_list=($(extract_chapter_list "$manga_name" "$html_chapter_list") )
debug_log chapter_list=${chapter_list[@]}
 
for chapter in ${chapter_list[@]}
do   
    if [[ "$chapter" -ge "$first_chapter" && "$chapter" -le "$end_chapter" ]]; then
        logfile "Downloading chapter $chapter"
        CHAPTER_OK=$false
        while [[ "$CHAPTER_OK" != "$true" ]]
        do
            # Pour un manga/chapitre, recuperation du fichier html contenant toute les url de page
            html_page_url_list=$(get_html_page_list "$manga_name" "$chapter")
            # Pour un manga, recuperation de la liste de numero de chapitre
            page_url_list=($(extract_page_url_list "$html_page_url_list") )
            # Lecture de toutes les pages de ce chapitre
            get_chapter "$manga_name" "$chapter" "${page_url_list[@]}"
            # Checks if there are 0 length file size
            src_folder="/home/user/Documents/Doc_Perso/Fred/ebook/Manga/$manga_name/Chapitre_"$chapter""
            file_zero_length=($(find "$src_folder" -name '*' -size 0) )
            CHAPTER_OK=$true
            if [[ "$file_zero_length" != "" ]]; then 
                CHAPTER_OK=$false
                for file in "${file_zero_length[@]}"
                do
                    rm $file
                done
            fi
            if [[ "$CHAPTER_OK" != "$true" ]]; then 
                logfile_err "Error detected, retry..."
            fi
        done
        # Just in case, cleaning old pdf
        rm ./$manga_name/$chapter/*.pdf
        convert_to_pdf $manga_name $chapter
    fi
done

logscreen_only
logscreen_only "LOGFILE is "$LOGFILE
logscreen_only
