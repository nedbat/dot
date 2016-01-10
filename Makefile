KEY_FILE = .ssh/other_authorized_keys
TAR_FILE = dot.tar
TGZ_FILE = dot.tgz
ZIP_FILE = dot.zip
UNTAR = tar xf $(TAR_FILE)

$(TAR_FILE) tar: .* $(KEY_FILE)
	tar -cvf $(TAR_FILE) --exclude-from=notar.txt .

$(TGZ_FILE) tgz: .* $(KEY_FILE)
	tar -cvzf $(TGZ_FILE) --exclude-from=notar.txt .

$(ZIP_FILE) zip: .*
	zip -r $(ZIP_FILE) bin .*vim* *.cmd *.bat *.ahk -x '*.git*'

$(KEY_FILE): .ssh/*.pub
	cat $^ > $@

copyplugs:
	rsync -a --exclude=.git ~/.vim/plugged .vim/plugged

unpack: webfaction dreamhost

webfaction: $(TAR_FILE)
	scp $(TAR_FILE) nedbat@nedbatchelder.com:.
	ssh nedbat@nedbatchelder.com $(UNTAR)

dreamhost: $(TAR_FILE)
	scp $(TAR_FILE) nedbat@nedbatchelder.net:.
	ssh nedbat@nedbatchelder.net $(UNTAR)

pos: $(TAR_FILE)
	scp $(TAR_FILE) $@:.
	ssh $@ $(UNTAR)

CYG_SSH = /home/ned/.ssh

cygwin: $(KEY_FILE)
	cp .ssh/config $(CYG_SSH)/config
	chmod 644 $(CYG_SSH)/*
	chmod 600 $(CYG_SSH)/id_dsa

clean:
	-rm -f $(TAR_FILE) $(TGZ_FILE) $(ZIP_FILE) $(KEY_FILE)
	find . -name '.DS_Store' -delete
	find . -print0 | xargs -0 xattr -c
