FOLDER=$1
FILTER=$2
AVI_FOUND=''
echo "Searching avi file in " $FOLDER
AVI_FOUND=$(find $FOLDER -iname '*.avi' | grep $2)
echo "AVI found with filter=" $AVI_FOUND

