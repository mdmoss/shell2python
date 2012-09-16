#!/bin/bash

# Matthew Moss
# mdm@cse.unsw.edu.au
# cs2041, 12s2


# A simple script for taking command line notes, labelled with current date
# Notes are to be passed as arguments

date=`date`
echo $date $@ >>notes.txt
