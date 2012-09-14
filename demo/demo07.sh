#!/bin/sh

# Prints directories one level deeper than current

for obj in $(ls)
do
    if test -d $obj
    then
        echo -n $obj ": "
        cd $obj
        ls 
        cd ..
    else
        echo $obj
    fi
done
