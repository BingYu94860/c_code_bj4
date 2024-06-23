
#----------#----------#----------#----------#----------#

## https://github.com/libexpat/libexpat/releases
wget https://github.com/libexpat/libexpat/releases/download/R_2_2_10/expat-2.2.10.tar.gz
tar zxvf expat-2.2.10.tar.gz
mv expat-2.2.10 libexpat

rm -f expat-2.2.10.tar.gz
rm -f libexpat/README.md
rm -f libexpat/COPYING
rm -f libexpat/ChangeLog

#----------#----------#----------#----------#----------#

cd libexpat/
mkdir -p m4
ACLOCAL_PATH=/usr/share/aclocal autoreconf -ivf
./configure
make
cd ..

#----------#----------#----------#----------#----------#
