#!/bin/bash -x
# John Boero
# Recursively build directories in parallel at arg $1.
# Defaults to current directory. Beware parallel usage.

function build_dir()
{
    pushd "$1"
    if [ "build.pkr.hcl" -nt ".build_timestamp" ]
    then
        packer build "$1" && touch ".build_timestamp" || return 1
    else
        echo "SKIP ${PWD}/build.pkr.hcl not modified since last successful build."
    fi

    find . -type d -maxdepth 1 | xargs build_dir
    popd
}

export -f build_dir

build_dir "${1:-.}"
