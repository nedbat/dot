.PHONY: help tar tgz zip shell copyvim difffiles clean dist

KEY_FILE = .ssh/other_authorized_keys
TAR_FILE = dot.tar
TGZ_FILE = dot.tgz
ZIP_FILE = dot.zip
EXTRACTOR_FILE = dot.sh
UNTAR = tar xf $(TAR_FILE)

help:					## Show this help
	@echo "Available make targets:"
	@grep '^[a-zA-Z]' $(MAKEFILE_LIST) | sort | awk -F ':.*?## ' 'NF==2 {printf "  %-26s%s\n", $$1, $$2}'

$(TAR_FILE) tar: .* $(KEY_FILE)
	tar -cvf $(TAR_FILE) --exclude-from=shex/notar.txt .

$(TGZ_FILE) tgz: .* $(KEY_FILE)
	tar -czf $(TGZ_FILE) --exclude-from=shex/notar.txt .

$(ZIP_FILE) zip: .*
	zip -r $(ZIP_FILE) bin .*vim* .git?* .hg* *.cmd *.bat *.ahk -x '.git'

$(KEY_FILE): .ssh/*.pub
	cat $^ > $@

shell: $(EXTRACTOR_FILE)		## Make self-extracting shell file
$(EXTRACTOR_FILE): $(TGZ_FILE)
	shex/make_extractor.sh $(TGZ_FILE) $(EXTRACTOR_FILE)
	@echo "Extractor file is $(EXTRACTOR_FILE). Copy to a machine, then:"
	@echo "prompt> ./$(EXTRACTOR_FILE)"

copyvim:				## Copy vim support files
	rsync -a -v --delete --exclude=.git ~/.vim/plugged .vim
	mkdir -p .vim/autoload
	cp ~/.vim/autoload/plug.vim .vim/autoload/plug.vim
	cp -R ~/.vim/spell .vim


IGNORE_DIFF = \( -name 'plugged' -o -name '.git' \)
difffiles:				## Compare these files to $HOME
	@echo '# Use this target like this:'
	@echo '#    . <(make difffiles)'
	@find . $(IGNORE_DIFF) -prune -o -type f -exec diff -q ~/{} {} \; 2>/dev/null | awk '{print "cp " $$2 " " $$4}'

CYG_SSH = /home/ned/.ssh

cygwin: $(KEY_FILE)
	cp .ssh/config $(CYG_SSH)/config
	chmod 644 $(CYG_SSH)/*
	chmod 600 $(CYG_SSH)/id_dsa

clean:					## Get rid of unneeded stuff
	-rm -f $(TAR_FILE) $(TGZ_FILE) $(ZIP_FILE) $(KEY_FILE)
	-rm -f $(EXTRACTOR_FILE)
	find . -name '.DS_Store' -delete
	find . -name '._*' -delete
	find . -print0 | xargs -0 xattr -c

dist: $(EXTRACTOR_FILE)			## Copy extractor to a few places
	cp $(EXTRACTOR_FILE) /src/edx/src
	scp $(EXTRACTOR_FILE) drop1:.
	scp $(EXTRACTOR_FILE) dreamhost:.
