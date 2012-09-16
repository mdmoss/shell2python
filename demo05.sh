#!/bin/sh

# Matthew Moss
# mdm@cse.unsw.edu.au
# cs2041, 12s2


# Check system status every ten minutes
# Taken from cs2041 shell slides 2012s2

while true
do
    uptime && sleep 600
done
