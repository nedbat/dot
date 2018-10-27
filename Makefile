KEY_FILE = .ssh/other_authorized_keys
TAR_FILE = dot.tar
TGZ_FILE = dot.tgz
ZIP_FILE = dot.zip
EXTRACTOR_FILE = dot.sh
UNTAR = tar xf $(TAR_FILE)

$(TAR_FILE) tar: .* $(KEY_FILE)
	tar -cvf $(TAR_FILE) --exclude-from=notar.txt .

$(TGZ_FILE) tgz: .* $(KEY_FILE)
	tar -cvzf $(TGZ_FILE) --exclude-from=notar.txt .

$(ZIP_FILE) zip: .*
	zip -r $(ZIP_FILE) bin .*vim* .git?* .hg* *.cmd *.bat *.ahk -x '.git'

$(KEY_FILE): .ssh/*.pub
	cat $^ > $@

$(EXTRACTOR_FILE) extractor: $(TGZ_FILE)
	./make_extractor.sh $(TGZ_FILE) $(EXTRACTOR_FILE)

copyvim:
	rsync -a -v --delete --exclude=.git ~/.vim/plugged .vim
	mkdir -p .vim/autoload
	cp ~/.vim/autoload/plug.vim .vim/autoload/plug.vim
	cp -R ~/.vim/spell .vim


IGNORE_DIFF = \( -name 'plugged' -o -name '.git' \)
difffiles:
	find . $(IGNORE_DIFF) -prune -o -type f -exec diff -q ~/{} {} \; 2>/dev/null

CYG_SSH = /home/ned/.ssh

cygwin: $(KEY_FILE)
	cp .ssh/config $(CYG_SSH)/config
	chmod 644 $(CYG_SSH)/*
	chmod 600 $(CYG_SSH)/id_dsa

clean:
	-rm -f $(TAR_FILE) $(TGZ_FILE) $(ZIP_FILE) $(KEY_FILE)
	-rm -f $(EXTRACTOR_FILE)
	find . -name '.DS_Store' -delete
	find . -name '._*' -delete
	find . -print0 | xargs -0 xattr -c
