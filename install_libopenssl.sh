
#----------#----------#----------#----------#----------#

wget https://github.com/openssl/openssl/releases/download/openssl-3.0.11/openssl-3.0.11.tar.gz
tar zxvf openssl-3.0.11.tar.gz
mv openssl-3.0.11 libopenssl

rm -f openssl-3.0.11.tar.gz

#----------#----------#----------#----------#----------#

cd libopenssl/
./config
make -j4

#----------#----------#----------#----------#----------#
