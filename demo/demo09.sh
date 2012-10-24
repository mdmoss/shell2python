#!/bin/bash

# Matthew Moss
# mdm@cse.unsw.edu.au
# cs2041, 12s2


# Print an increasing sequence of numbers

if test $# -ne 1
then
    echo "Usage: $0 start"
    exit 1
fi

num=$1

while test $num -lt 100000000
do
    echo $num
    num=`expr $num \* $num`
done
