#!/bin/sh

# We're going to do some horrible things with backtics here
a=`expr 1 + 1`
b=`expr 1 + $a`
c=`expr $a + $b + $a`
echo $a $b $c
d=`ls`
e=`pwd`
echo $e
echo $d

# Time for switch / case!
var=1;
# Neat ones
case $var in
    1)
        echo "1"
        ;;
    2)
        echo "2"
        ;;
esac

# And ugly ones

case $var in 
1) echo "1" ;; 
2) echo "2" ;; 
esac
