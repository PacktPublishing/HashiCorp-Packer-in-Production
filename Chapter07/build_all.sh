#!/bin/bash -x
# John Boero
# Recursively build directories in parallel at arg $1.
# Defaults to current directory. Beware parallel usage.

function build_dir()
{
    packer build "$1"
    find . -type d | xargs build_dir
}

export -f build_dir

build_dir "${1:-.}"