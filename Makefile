VERSION = v5.002
INTALL_PATH = /opt/verilator-$(VERSION)

clone:
	git clone https://github.com/verilator/verilator.git

checkout: clone
	cd verilator
	git pull
	git checkout $(VERSION)

configure: checkout
	autoconf
	./configure --prefix=$(INTALL_PATH)

make: configure
	make -j `nproc`

test: make
	make test

install: test
	make install
