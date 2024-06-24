
#----------#----------#----------#----------#----------#

wget https://github.com/GNOME/libxml2/archive/refs/tags/v2.9.10.tar.gz
tar zxvf v2.9.10.tar.gz
mv libxml2-2.9.10 libxml2

rm -f v2.9.10.tar.gz

#----------#----------#----------#----------#----------#

cd libxml2/
mkdir -p m4
ACLOCAL_PATH=/usr/share/aclocal autoreconf -ivf
./configure
make -j4
cd ..

#----------#----------#----------#----------#----------#
