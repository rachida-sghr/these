#!/bin/bash

function prepare_build_dir() {
    echoinfo "preparing the build directory"
    if [ -d ${BUILD_DIR} ] ; then
        rm -rf ${BUILD_DIR}
    fi
    mkdir ${BUILD_DIR}
    cp manuscrit/*.{tex,bib,bst} ${BUILD_DIR}/
    cd ${BUILD_DIR}
    ln -s ../figures figures 
    ln -s ../manuscrit/includes includes
    cd ..
}

function compile() {
    local build_type=${1}
    local interactive=${2}
    local verbose=${3}

    # replace the figures
    local tex_files=${BUILD_DIR}/*.tex
    for file in $tex_files; do
        replace_figures ${file} ${build_type}
    done

    # run latexmk
    compile_cmd="latexmk -cd ${BUILD_DIR}/main.tex -r latexmkrc"

    if [ "${interactive}" = "false" ] ; then
        compile_cmd="${compile_cmd} -halt-on-error"
    fi

    if [ "${verbose}" = "false" ] ; then
        local logs="${BUILD_DIR}/latexmk.log"
        echoinfo "Running ${compile_cmd}. Logs are in ${logs}."
        ${compile_cmd} >${logs} 2>&1 || {
            echoerr "Build failed!"
            echoerr "Check out ${BUILD_DIR}/latexmk.log for build logs"
            exit 1
        }
    else
        echoinfo "Running ${compile_cmd}"
        ${compile_cmd} || {
            echoerr "Build failed!"
            exit 1
        }
    fi 
}

function replace_figures() {
    local file=${1}
    local build_type=${2}

    if [ ${build_type} = "FULL" ] ; then
        echoinfo "Replacing figures in ${file} by beautiful but long to compile tikz figures."
        sed -i.bk 's/%_BUILD_FULL\s*\(.*\)$/\1 %_BUILD_FULL/g' ${file}
        sed -i.bk 's/\(.*\)\s*%_BUILD_QUICK\(.*\)$/%_BUILD_QUICK \1/g' ${file}
    elif [ ${build_type} = "QUICK" ] ; then
        echoinfo "Replacing figures in ${file} by quick to compile but not so nice figures."
        sed -i.bk 's/%_BUILD_QUICK\s*\(.*\)$/\1 %_BUILD_QUICK/g' ${file}
        sed -i.bk 's/\(.*\)\s*%_BUILD_FULL \(.*\)$/%_BUILD_FULL \1/g' ${file}
    fi
}

function main() {
    local build_type="FULL"
    local verbose=false
    local interactive=false

    while getopts "vdihq" param
    do
        case ${param} in
            v) verbose=true       ;;
            d) set -o xtrace      ;;
            i) interactive=true   ;;
            q) build_type="QUICK" ;;
            h) usage ; return     ;;
        esac
    done

    prepare_build_dir
    compile ${build_type} ${interactive} ${verbose}
    echoinfo "Compilation successful!"
    mv ${BUILD_DIR}/main.pdf these.pdf
    echoinfo "You can now open these.pdf"
}

function echoinfo {
    printf "\033[0;32m*** %s ***\033[0m\n" "$@"
}

function echoerr() {
    printf "\033[0;31m*** %s ***\033[0m\n" "$@" 1>&2
}

set -o errexit
BUILD_DIR="./build"
main $@
