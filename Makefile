.PHONY: These.pdf all clean

all: These.pdf
	[ -d build ] || mkdir build
	latexmk -cd manuscrit/These.tex -output-directory=../build/
	mv build/These.pdf .

clean:
	rm -rf build
