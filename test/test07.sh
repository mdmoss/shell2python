#!/bin/sh

# Matthew Moss
# mdm@cse.unsw.edu.au
# cs2041, 12s2


# Nested if statements with variables. Crazy stuff

i=1
j=2
k=3
if `test i`
then
    if `test $j -eq $k`
    then
        echo j equals k
    elif `test $j`
    then
        echo j is not zero
    fi
fi
