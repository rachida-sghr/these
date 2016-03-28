BUILD_DIR=build/

function setup() {
    rm -rf ${BUILD_DIR}
    mkdir ${BUILD_DIR}
    cd ${BUILD_DIR}
    ln -s .. figures
    cd ..
}

function cleanup() {
    rm -rf ${BUILD_DIR}
}

function main() {
    local filename=
    local file=
    setup
    for file in $@
    do
        cp -f ${file} ${BUILD_DIR}/
        filename=$(basename ${file})
        compile "$(dirname ${file})/${filename%.*}"
    done
    cleanup
}

function compile() {
    local target=${1}
    local base=$(basename ${target})

    cat<<EOF>${BUILD_DIR}/build.tex
\documentclass[a4paper,11pt,twoside]{book}

\usepackage[T1]{fontenc}
\usepackage[utf8]{inputenc}
\usepackage[french]{babel}
\usepackage{color}
\usepackage{graphicx}
\usepackage{amsthm}
% http://tex.stackexchange.com/questions/174903/justified-text-extending-beyond-margin
\usepackage{microtype}
\usepackage[nomain,acronym,xindy,toc]{glossaries}
\input{../../manuscrit/glossaire}
\input{../../manuscrit/includes/listings}
\input{../../manuscrit/includes/figures}

\begin{document}
\input{../${target}}
\end{document}
EOF

    latexmk -r ../latexmkrc -cd ${BUILD_DIR}/build.tex -output-directory=../${BUILD_DIR}
	mv build/build.pdf ${base}.pdf
}
set -x
main $@
