INSTALL ?= install
PREFIX ?= /usr/local

all:
	@echo "Nothing to build. Use 'make install' to install."

install:
	mkdir -p $(DESTDIR)$(PREFIX)/lib/rpm/fileattrs
	$(INSTALL) -m0644 R.attr $(DESTDIR)$(PREFIX)/lib/rpm/fileattrs
	mkdir -p $(DESTDIR)$(PREFIX)/lib/rpm/macros.d
	$(INSTALL) -m0644 macros.R-extra $(DESTDIR)$(PREFIX)/lib/rpm/macros.d
	$(INSTALL) -m0755 R-deps.R $(DESTDIR)$(PREFIX)/lib/rpm/
