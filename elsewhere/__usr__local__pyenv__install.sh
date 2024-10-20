# https://github.com/pyenv/pyenv/blob/master/plugins/python-build/README.md#building-for-maximum-performance
PYTHON_CONFIGURE_OPTS='--enable-optimizations --with-lto' PYTHON_CFLAGS='-march=native -mtune=native' pyenv install --force $1
