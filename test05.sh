#/bin/sh

# Matthew Moss
# mdm@cse.unsw.edu.au
# cs2041, 12s2


# We're going to have nested loops

for i in 1 2 3 
do
    for j in 4 5 6
    do
        while `test $i -lt $j`
        do
            echo $1
            $i = `expr $1 + 1`
        done
    done
done
