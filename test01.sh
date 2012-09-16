#!/bin/bash

# Matthew Moss
# mdm@cse.unsw.edu.au
# cs2041, 12s2


# We'll start with a for loop. Everyone likes for loops.

for n in 1 2 3
do
    read name
    echo name $n is $name
    pwd
done

cd /
pwd

for object in *
do
    echo $object
done
for object in *.sh
do
    echo $object
done
for object in file.*
do
    echo $object
done
for object in *.[ch]
do
    echo $object
done

exit 123
