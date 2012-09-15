#!/bin/sh

# Celcius ->  Farenheit converter

if `test $# -ne 1`; then
    echo Usage: $0 degrees 
    exit 1
fi

res=`expr $1 \* 9 \/ 5 \+ 32`
echo $res
