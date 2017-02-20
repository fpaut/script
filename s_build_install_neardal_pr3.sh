#! /bin/bash
make clean  && ./configure --prefix=/usr/local && make && sudo make install && scp /usr/local/bin/ncl root@192.168.100.1:/usr/bin &&  scp /usr/local/lib/libneardal.* root@192.168.100.1:/usr/lib
