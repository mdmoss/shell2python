#!/bin/bash

# Tests if a user is... someone? These demos are weird...

name=$1
user=`whoami`
if test $name = $user; then
    echo Correct user && exit 0
else
    echo Incorrect user && exit 1 
fi
