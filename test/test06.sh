#!/bin/sh

# Matthew Moss
# mdm@cse.unsw.edu.au
# cs2041, 12s2


# We're going crazy town with escaping
a=\$a
b='\\$b'
c="\$c"

echo $a $b $c
