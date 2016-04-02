.PHONY: These.pdf all clean figures

all: These.pdf
	[ -d build ] || mkdir build
	latexmk -cd manuscrit/main.tex -output-directory=../build/ -auxdir=../build
	mv build/main.pdf these.pdf

figures:
	cd figures ; find . -path ./lib -prune -o -maxdepth 2 -iname *.tex -exec ./build.sh  {} \; ; cd :
	rm -rf build

clean:
	rm -rf build
