wget https://github.com/strophe/libstrophe/releases/download/0.10.1/libstrophe-0.10.1.tar.gz

tar zxvf libstrophe-0.10.1.tar.gz

mv libstrophe-0.10.1 libstrophe

#----------#----------#----------#----------#----------#

patch -p0 < libstrophe_sha_h.patch
patch -p0 < libstrophe_configure_ac.patch

rm -rf libstrophe-0.10.1.tar.gz
rm -rf libstrophe/docs/
rm -rf libstrophe/TODO
rm -rf libstrophe/NEWS
rm -rf libstrophe/README
rm -rf libstrophe/AUTHORS
rm -rf libstrophe/COPYING
rm -rf libstrophe/ChangeLog
rm -rf libstrophe/LICENSE.txt
rm -rf libstrophe/MIT-LICENSE.txt
rm -rf libstrophe/GPL-LICENSE.txt
rm -rf libstrophe/examples/README.md

cd libstrophe/

#----------#----------#----------#----------#----------#

# sudo apt-get update
# sudo apt-get upgrade

## autoreconf: not found
# sudo apt-get install autoconf

## Can't exec "libtoolize": No such file or directory at /usr/share/autoconf/Autom4te/FileUtils.pm line 293.
## autoreconf: error: libtoolize failed with exit status: 2
# sudo apt-get install build-essential libtool

## configure: error: openssl not found; openssl required
# sudo apt-get install libssl-dev

## configure: error: no XML parser was found, libstrophe requires expat or libxml2
## https://github.com/libexpat/libexpat/releases
# sudo apt-get install libxml2-dev

## ./configure: line 13635: syntax error near unexpected token `openssl,'
## ./configure: line 13635: ` PKG_CHECK_MODULES(openssl, openssl,'
# sudo apt-get install pkg-config

#----------#----------#----------#----------#----------#

mkdir -p m4
ACLOCAL_PATH=/usr/share/aclocal autoreconf -ivf
./configure
make

#----------#----------#----------#----------#----------#


cd ..
