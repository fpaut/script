CH=$1
URL_OK=0
while [[ "$URL_OK" == "0" ]]
do
    CHAPITRE=$CH
    if [[ "${#CH}" == "1" ]]; then
        CHAPITRE="0"$CH
        echo CHAPITRE=$CHAPITRE > /dev/stderr
    fi
    echo Getting Chapter $CHAPITRE
    URL="https://boruto-france.fr/boruto-chapitre-$CHAPITRE-fr/"
    # Test URL
    wget $URL -o ./dummy
    URL_OK=$?
    rm ./dummy
    if [[ "$URL_OK" == "0" ]]; then
        boruto_jpg_to_pdf.sh $CHAPITRE
    else
        exit
    fi
    CH=$(($CH + 1))
#URL_OK=1
done
