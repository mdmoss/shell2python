#!/bin/bash

# A simple script for taking command line notes, labelled with current date
# Notes are to be passed as arguments

date=`date`
echo $date $@ >>notes.txt
