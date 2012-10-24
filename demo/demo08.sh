#!/bin/bash

# Matthew Moss
# mdm@cse.unsw.edu.au
# cs2041, 12s2


# Chorus

if test $# -ne 1; then
    echo Usage: $0 voices
    exit 1
fi

while true
do
    read line
    count=0
    while test $count -lt $1
    do
        echo $line
        count=`expr $count + 1`
    done
done
