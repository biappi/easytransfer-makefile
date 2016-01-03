ef3xfer: the_deps Packages/easyflash/EasyTransfer/out/easytransfer/ef3xfer
	cp Packages/easyflash/EasyTransfer/out/easytransfer/ef3xfer .

the_deps:\
	Packages/easyflash/.extracted \
	Packages/cc65/.extracted \
	Packages/cc65-c64/.extracted \
	Prefix/include/ftdi.h

Packages/easyflash/EasyTransfer/out/easytransfer/ef3xfer: PATH := $(PATH):$(CURDIR)/Packages/cc65/bin
Packages/easyflash/EasyTransfer/out/easytransfer/ef3xfer: export CC65_INC := $(CURDIR)/Packages/cc65/include
Packages/easyflash/EasyTransfer/out/easytransfer/ef3xfer: export LD65_LIB := $(CURDIR)/Packages/cc65-c64/lib
Packages/easyflash/EasyTransfer/out/easytransfer/ef3xfer: export CFLAGS += -I$(CURDIR)/Prefix/include
Packages/easyflash/EasyTransfer/out/easytransfer/ef3xfer: export LDFLAGS += $(CURDIR)/Prefix/lib/libftdi.a
Packages/easyflash/EasyTransfer/out/easytransfer/ef3xfer: export LDFLAGS += $(CURDIR)/Prefix/lib/libusb.a
Packages/easyflash/EasyTransfer/out/easytransfer/ef3xfer: export LDFLAGS += $(CURDIR)/Prefix/lib/libusb-1.0.a
Packages/easyflash/EasyTransfer/out/easytransfer/ef3xfer: export LDFLAGS += -framework CoreFoundation
Packages/easyflash/EasyTransfer/out/easytransfer/ef3xfer: export LDFLAGS += -framework IOKit
Packages/easyflash/EasyTransfer/out/easytransfer/ef3xfer: export LDFLAGS += -lobjc
Packages/easyflash/EasyTransfer/out/easytransfer/ef3xfer:
	$(MAKE) -C Packages/easyflash/EasyTransfer ef3xfer

Prefix/bin/pkg-config: export LDFLAGS += -framework CoreFoundation -framework Carbon
Prefix/bin/pkg-config: Packages/pkg-config-0.29/.extracted
	cd Packages/pkg-config-0.29 ; ./configure --prefix="$(CURDIR)/Prefix" --with-internal-glib
	cd Packages/pkg-config-0.29 ; make
	cd Packages/pkg-config-0.29 ; make install

Prefix/include/libusb-1.0/libusb.h: Packages/libusb-1.0.20/.extracted
	cd Packages/libusb-1.0.20 ; ./configure --prefix="$(CURDIR)/Prefix"
	cd Packages/libusb-1.0.20 ; make
	cd Packages/libusb-1.0.20 ; make install

Prefix/include/ftdi.h: PATH := $(PATH):$(CURDIR)/Prefix/bin
Prefix/include/ftdi.h: Packages/libftdi-0.20/.extracted Prefix/bin/libusb-config
	cd Packages/libftdi-0.20 ; ./configure --prefix="$(CURDIR)/Prefix"
	cd Packages/libftdi-0.20 ; make
	cd Packages/libftdi-0.20 ; make install

Prefix/bin/libusb-config: PATH := $(PATH):$(CURDIR)/Prefix/bin
Prefix/bin/libusb-config: \
	Packages/libusb-compat-0.1.5/.extracted \
	Prefix/bin/pkg-config \
	Prefix/include/libusb-1.0/libusb.h
	cd Packages/libusb-compat-0.1.5 ; ./configure --prefix="$(CURDIR)/Prefix"
	cd Packages/libusb-compat-0.1.5 ; make
	cd Packages/libusb-compat-0.1.5 ; make install

Packages/libusb-compat-0.1.5/.extracted: Archives/libusb-compat-0.1.5.tar.bz2
	tar -xjf Archives/libusb-compat-0.1.5.tar.bz2 --directory Packages
	touch Packages/libusb-compat-0.1.5/.extracted

Packages/pkg-config-0.29/.extracted: Archives/pkg-config-0.29.tar.gz
	tar -xzf Archives/pkg-config-0.29.tar.gz --directory Packages/
	touch Packages/pkg-config-0.29/.extracted

Packages/libusb-1.0.20/.extracted: Archives/libusb-1.0.20.tar.bz2
	tar -xjf Archives/libusb-1.0.20.tar.bz2 --directory Packages/
	touch Packages/libusb-1.0.20/.extracted

Packages/libftdi-0.20/.extracted: Archives/libftdi-0.20.tar.gz
	tar -xzf Archives/libftdi-0.20.tar.gz --directory Packages/
	touch Packages/libftdi-0.20/.extracted

Packages/cc65-c64/.extracted: Archives/cc65-c64-2.13.3-1.zip
	mkdir -p Packages/cc65-c64
	unzip Archives/cc65-c64-2.13.3-1.zip -d Packages/cc65-c64
	touch Packages/cc65-c64/.extracted

Packages/cc65/.extracted: Archives/cc65-osx107-2.13.3-1.tar.gz
	mkdir -p Packages/cc65
	tar -xzf Archives/cc65-osx107-2.13.3-1.tar.gz --directory Packages/cc65
	touch Packages/cc65/.extracted

Packages/easyflash/.extracted: Archives/easyflash.tar.gz
	mkdir -p Packages/easyflash
	tar -xzf Archives/easyflash.tar.gz --directory Packages/easyflash --strip-components=1
	touch Packages/easyflash/.extracted
	# don't want to download imagemagik for this
	mkdir -p Packages/easyflash/EasyTransfer/out/obj/
	touch Packages/easyflash/EasyTransfer/out/obj/easytransfer.xpm
	# patching -Wl,--strip-all out
	grep -v strip.all Packages/easyflash/EasyTransfer/Makefile > Packages/easyflash/EasyTransfer/Makefile.1
	# removing -lftdi, i will pass the static libraries with LDFLAGS
	sed "s/-lftdi//g" Packages/easyflash/EasyTransfer/Makefile.1 > Packages/easyflash/EasyTransfer/Makefile

Archives/libusb-compat-0.1.5.tar.bz2:
	mkdir -p Archives
	curl -L -o Archives/libusb-compat-0.1.5.tar.bz2 http://sourceforge.net/projects/libusb/files/libusb-compat-0.1/libusb-compat-0.1.5/libusb-compat-0.1.5.tar.bz2/download

Archives/pkg-config-0.29.tar.gz:
	mkdir -p Archives
	cd Archives; curl -O http://pkgconfig.freedesktop.org/releases/pkg-config-0.29.tar.gz

Archives/libusb-1.0.20.tar.bz2:
	mkdir -p Archives
	curl -L -o Archives/libusb-1.0.20.tar.bz2 http://sourceforge.net/projects/libusb/files/libusb-1.0/libusb-1.0.20/libusb-1.0.20.tar.bz2/download

Archives/libftdi-0.20.tar.gz:
	mkdir -p Archives
	cd Archives; curl -O https://www.intra2net.com/en/developer/libftdi/download/libftdi-0.20.tar.gz

Archives/cc65-c64-2.13.3-1.zip:
	mkdir -p Archives
	cd Archives; curl -O http://cc65.atarinet.com/cc65-c64-2.13.3-1.zip

Archives/cc65-osx107-2.13.3-1.tar.gz:
	mkdir -p Archives
	cd Archives ; curl -O http://cc65.atarinet.com/cc65-osx107-2.13.3-1.tar.gz

Archives/easyflash.tar.gz:
	mkdir -p Archives
	curl -o Archives/easyflash.tar.gz https://bitbucket.org/skoe/easyflash/get/tip.tar.gz

