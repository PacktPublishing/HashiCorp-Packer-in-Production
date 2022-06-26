#!/bin/bash
# John Boero
# A script to parse and split machine-readable Packer machine readable output into multiple files.
# Note this saves logs to arg1 or ./logs/ by default, appending along the way.

d=${1:-logs}
mkdir -p "$d"

while read l
do
    export IFS=','
    stream=$(echo $l | awk {'print $2'})
    echo "$l"
    echo "$l" >> "$d/$stream.log"
done