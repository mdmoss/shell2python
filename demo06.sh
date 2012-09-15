#!/bin/bash

# Tests if a user is... someone? These demos are weird...

name=$1
user=`whoami`
if test $name = $user; then
    exit 0
else
    exit 1 
fi
