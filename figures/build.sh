BUILD_DIR=build/

function setup() {
    rm -rf ${BUILD_DIR}
    mkdir ${BUILD_DIR}
}

function cleanup() {
    rm -rf ${BUILD_DIR}
}

function main() {
    local fullname=
    local name=
    local files="*.tex"
    setup
    if [ ! -z $@ ] ; then
        files=$@
    fi
    for file in ${files}
    do
        cp -f ${file} ${BUILD_DIR}/
        fullname=$(basename ${file})
        name="${fullname%.*}"
        compile ${name}
    done
    cleanup
}

function compile() {
    local target=${1}

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
% tables
\usepackage{adjustbox}
\usepackage{arydshln,tabulary,multirow,booktabs,array}

% tikz
\usepackage{tikz}
\usetikzlibrary{calc}
\usetikzlibrary{mindmap,trees}
\tikzset{concept/.append style={fill={none}}}

% table lengths
\setlength{\dashlinedash}{0.5pt}
\setlength{\dashlinegap}{1pt}
\setlength{\arrayrulewidth}{0.5pt}

\begin{document}
\include{${target}}
\end{document}
EOF

    latexmk -r ../latexmkrc -cd ${BUILD_DIR}/build.tex -output-directory=../${BUILD_DIR}
	mv build/build.pdf ${target}.pdf
}
set -x
main $@
