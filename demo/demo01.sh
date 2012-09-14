#!/bin/sh

# Inspired by iota.sh from cs2041 2012s2 lecture examples

# Prints numbers in the range of two arguments

if test $# = 1
then
    start=1
    finish=$1
elif test $# = 2
then
    start=$1
    finish=$2
else
    echo "Usage: $0 [start] [finish]"
    exit 1
fi

number=$start
while test $number -le $finish
do
    echo $number
    number=`expr $number + 1`
done

