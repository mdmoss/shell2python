#!/usr/bin/python2.7 -u
import subprocess

# The most trivial of examples, translating digits
# Taken from cs2041 labs, week 3 2012s2

# Original name: digits.sh

subprocess.call(['tr', '0123456789', '<<<<<5>>>>'])
