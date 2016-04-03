.PHONY: all clean figures full quick dev

all:
	./build.sh

full:
	./build.sh -i -v 

quick:
	./build.sh -q -i -v

dev:
	./build.sh -q

figures:
	cd figures ; find . -path ./lib -prune -o -maxdepth 2 -iname *.tex -exec ./build.sh  {} \; ; cd :
	rm -rf build

clean:
	rm -rf build
