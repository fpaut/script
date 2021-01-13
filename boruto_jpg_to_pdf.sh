CHAPITRE=$1
URL="https://boruto-france.fr/boruto-chapitre-$CHAPITRE-fr/"
FOLDER="/home/user/websites/Boruto/$CHAPITRE"
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
CMD="rm -rf $FOLDER"; echo $CMD; eval "$CMD"
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
CMD="httrack --update https://boruto-france.fr/boruto-chapitre-$CHAPITRE-fr/ +*uploads/2018/*.png +*uploads/2018/*.jpg +*uploads/2018/*.jpeg  -*x* -mime:application/* -O $FOLDER"; echo $CMD; eval "$CMD"
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
CMD="rm -v $FOLDER/boruto-france.fr/wp-content/uploads/2017/08/*x*"; echo $CMD; eval "$CMD"
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
CMD="cd $FOLDER/boruto-france.fr/wp-content/uploads"; echo $CMD; $CMD
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
CMD="convert -define registry:temporary-path=~/tmp -limit memory 16mb -limit area 0 ./* /home/user/Documents/Doc_Perso/Fred/ebook/Boruto/test/Boruto-$CHAPITRE.pdf"; echo $CMD; eval "$CMD"
CMD="cd -"; echo $CMD; eval "$CMD"
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
echo "~/Documents/Doc_Perso/Fred/ebook/Boruto/test/Boruto-$CHAPITRE.pdf done!"
echo "££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££"
