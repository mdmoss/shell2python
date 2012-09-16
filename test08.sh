#!/bin/sh

# Matthew Moss
# mdm@cse.unsw.edu.au
# cs2041, 12s2


# We're going to do some horrible things with backtics here
a=`expr 1 + 1`
b=`expr 1 + $a`
c=`expr $a + $b + $a`
echo $a $b $c
d=`ls`
e=`pwd`
echo $e
echo $d
