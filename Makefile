KEY_FILE = .ssh/other_authorized_keys
TAR_FILE = dot.tar
UNTAR = tar xf $(TAR_FILE)

$(TAR_FILE) tar: .* $(KEY_FILE)
	#tar -cvf $(TAR_FILE) --mode=755 --exclude-from=notar.txt .
	tar -cvf $(TAR_FILE) --exclude-from=notar.txt .

$(KEY_FILE): .ssh/*.pub
	cat $^ > $@

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
	-rm -f $(TAR_FILE) $(KEY_FILE)
	find . -name '.DS_Store' -delete
	find . -print0 | xargs -0 xattr -c
