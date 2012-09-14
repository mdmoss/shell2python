#!/usr/bin/python2.7 -u
import sys

# Inspired by iota.sh from cs2041 2012s2 lecture examples

# Prints numbers in the range of two arguments

if len(sys.argv[1:]) == 1:
    start = 1
    finish = sys.argv[1]
elif len(sys.argv[1:]) == 2:
    start = sys.argv[1]
    finish = sys.argv[2]
else:
    print "Usage: " + str(0) + " [start] [finish]"
    sys.exit(1)

number = start
while int(number) <= int(finish):
    print number
    number = int(number) + 1

