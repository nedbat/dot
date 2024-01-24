#sudo apt update
#sudo apt-get install libcurl4-gnutls-dev
#mkvirtualenv -p python3.9 bug1443
#git clone --depth=1 https://github.com/seanxiaoyan/salt.git
#cd salt
#python -m pip install nox
python3.9 -m nox -e "pytest-3.9(coverage=True)" -- tests/integration
