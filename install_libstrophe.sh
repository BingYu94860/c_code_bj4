wget https://github.com/strophe/libstrophe/releases/download/0.10.1/libstrophe-0.10.1.tar.gz
tar zxvf libstrophe-0.10.1.tar.gz
mv libstrophe-0.10.1 libstrophe

#----------#----------#----------#----------#----------#

patch -p0 < patch/libstrophe_sha_h.patch
patch -p0 < patch/libstrophe_configure_ac.patch

rm -f libstrophe-0.10.1.tar.gz
rm -f libstrophe/TODO
rm -f libstrophe/NEWS
rm -f libstrophe/README
rm -f libstrophe/AUTHORS
rm -f libstrophe/COPYING
rm -f libstrophe/ChangeLog
rm -f libstrophe/LICENSE.txt
rm -f libstrophe/MIT-LICENSE.txt
rm -f libstrophe/GPL-LICENSE.txt
rm -f libstrophe/examples/README.md
rm -f libstrophe/docs/footer.html
rm -rf libstrophe/docs/

#----------#----------#----------#----------#----------#

# sudo apt-get update
# sudo apt-get upgrade

## autoreconf: not found
# sudo apt-get install autoconf

## Can't exec "libtoolize": No such file or directory at /usr/share/autoconf/Autom4te/FileUtils.pm line 293.
## autoreconf: error: libtoolize failed with exit status: 2
# sudo apt-get install build-essential libtool

## configure: error: openssl not found; openssl (3.0.11) required
## https://github.com/openssl/openssl/releases
# sudo apt-get install libssl-dev

## configure: error: no XML parser was found, libstrophe requires expat (2.2.10) or libxml2 (2.9.10)
## https://github.com/libexpat/libexpat/releases
## expat, libxml2, libroxml, ezxml
# sudo apt-get install expat
# sudo apt-get install libxml2-dev

## ./configure: line 13635: syntax error near unexpected token `openssl,'
## ./configure: line 13635: ` PKG_CHECK_MODULES(openssl, openssl,'
# sudo apt-get install pkg-config

#----------#----------#----------#----------#----------#

cd libstrophe/
mkdir -p m4
ACLOCAL_PATH=/usr/share/aclocal autoreconf -ivf
./configure
make -j4
cd ..

#----------#----------#----------#----------#----------#
