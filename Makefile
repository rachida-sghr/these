.PHONY: These.pdf all clean

all: These.pdf
	[ -d build ] || mkdir build
	latexmk -cd manuscrit/main.tex -output-directory=../build/
	mv build/main.pdf these.pdf

clean:
	rm -rf build
