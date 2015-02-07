PREFIX=/usr
VERSION=2.5.0

all:
	./buildallsizes.sh

clean:
	rm -rf 16x16 24x24 32x32 48x48

install:
	mkdir -p $(DESTDIR)$(PREFIX)/share/icons/oxygenrefit2
	cp -rv 16x16 24x24 32x32 48x48 index.theme $(DESTDIR)$(PREFIX)/share/icons/oxygenrefit2/
	gtk-update-icon-cache $(DESTDIR)$(PREFIX)/share/icons/oxygenrefit2
