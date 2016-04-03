La compilation necessite

- une distribution `LaTeX` incluant `pdflatex` et `latexmk`
- un shell unix (teste avec `bash` et `zsh`)
- `make`

Plusieurs options sont possibles pour compiler la these.

- `make dev`: les figures trop longues a compilees sont remplacees par des pdf.
- `make full`: les figures longues a compilees sont conservees, ce qui augmente
  significativement le temps de compilation.
- `make`: les figures longues a compilees sont conservees, ce qui augmente
  significativement le temps de compilation. L'output de `pdflatex` est masque.

La compilation "rapide" prend environ 20s. La compilation complete prend
environ 1m20s.
