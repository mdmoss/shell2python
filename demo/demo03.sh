#!/bin/sh

# Matthew Moss
# mdm@cse.unsw.edu.au
# cs2041, 12s2


# A simple guessing game
# May be used to entertain small children or the like

if `test $# -eq 0`; then
    echo "Usage: $1 target_number"
    exit 1
    fi

echo 'Welcome to MEGAGUESS'
echo -n 'Enter your name: '
read name
echo "Hello $name"

guess=0 # Starts of as an incorrect guess
while `test $guess -ne $1`;
do
    echo -n "What is your guess? "
    read guess
    if `test $guess -ne $1`; then
        echo "Wrong! Dead wrong! Guess again!"
    fi
done

echo "Wow, well done!"
echo "$guess is correct!"
