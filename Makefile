
all: configure
	cd src/ && make
	cd src/ && make check

configure:
	@#./configure
	./configure  --ignore-absence-of-libsigsegv

clean:
	cd src/ && make clean

.PHONY: all configure clean
