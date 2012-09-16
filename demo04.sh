#!/bin/sh

# Matthew Moss
# mdm@cse.unsw.edu.au
# cs2041, 12s2


# Celcius ->  Farenheit converter

if `test $# -ne 1`; then
    echo Usage: $0 degrees 
    exit 1
fi

res=`expr $1 \* 9 \/ 5 \+ 32`
echo $res
