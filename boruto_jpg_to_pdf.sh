CHAPITRE=$1
HTTRACK_FILTER=$2
if [ "$#" -ne 2 ]; then 
    HTTRACK_FILTER="+uploads/2018/*.png +*uploads/2018/*.jpg +*uploads/2018/*.jpeg  -*x*"
    echo "using default httrack filter (=$HTTRACK_FILTER)"
fi
URL="https://boruto-france.fr/boruto-chapitre-$CHAPITRE-fr/"
URL_OUTPUT="/home/user/websites/Boruto/$CHAPITRE/web"
PDF_OUTPUT="/home/user/Documents/Doc_Perso/Fred/ebook/Boruto/test/Boruto-chapitre-$CHAPITRE.pdf"
echo INPUT=$URL
echo URL_OUTPUT=$URL_OUTPUT
echo PDF_OUTPUT=$PDF_OUTPUT
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
CMD="rm -rf $URL_OUTPUT"; echo $CMD; eval "$CMD"
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
CMD="httrack https://boruto-france.fr/boruto-chapitre-$CHAPITRE-fr/ $HTTRACK_FILTER -O $URL_OUTPUT --file-log $URL_OUTPUT/Boruto-chapitre-$CHAPITRE.log"; echo $CMD; eval "$CMD"
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
##CMD="rm -v $URL_OUTPUT/boruto-france.fr/wp-content/uploads/2017/08/*x*"; echo $CMD; eval "$CMD"
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
CMD="cd $URL_OUTPUT/boruto-france.fr/wp-content/uploads"; echo $CMD; $CMD
ERR=$?
echo ERR=$ERR
if [[ "$ERR" != "0" ]]; then
    exit 1
fi
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
#First year found
CMD="cd *"; echo $CMD; $CMD
ERR=$?
echo ERR=$ERR
if [[ "$ERR" != "0" ]]; then
    exit 1
fi
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
#First month found
CMD="cd *"; echo $CMD; $CMD
ERR=$?
echo ERR=$ERR
if [[ "$ERR" != "0" ]]; then
    exit 1
fi
echo img_to_pdf.sh "*.jpg" "$PDF_OUTPUT"
