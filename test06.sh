#!/bin/sh

# We're going crazy town with escaping
a=\$a
b='\\$b'
c="\$c"

echo $a $b $c
