FILE_IN=$1
FILE_OUT=$1'.avi'
echo FILE_IN=$FILE_IN
echo FILE_OUT=$FILE_OUT
avconv -i $FILE_IN -same_quant $FILE_OUT
