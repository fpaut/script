#! /bin/bash

echo "valgrind "$1
valgrind --verbose --trace-children=yes --track-fds=yes --log-file=./valgrind.log.txt --demangle=yes --read-var-info=yes --show-emwarns=yes --leak-check=full --leak-resolution=high $1
