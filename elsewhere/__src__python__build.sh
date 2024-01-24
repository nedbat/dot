make distclean
./configure --prefix=/usr/local/cpython --with-openssl=$(brew --prefix openssl)
make -j
rm -rf /usr/local/cpython/*
echo make install, but quietly
make install >/dev/null
