.PHONY: These.pdf all clean figures

all: These.pdf
	[ -d build ] || mkdir build
	latexmk -cd manuscrit/main.tex -output-directory=../build/ -auxdir=../build
	mv build/main.pdf these.pdf

figures:
	cd figures ; ./build.sh ; cd ..

clean:
	rm -rf build
