for py in 3.6 3.7 3.8 3.9 3.10; do
    echo '----' $py 
    python$py -m pip install -U pip
    python$py -m pip install -U virtualenv virtualenvwrapper
done
