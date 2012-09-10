#!/usr/bin/python2.7 -u
import os
import subprocess

# This is a test of Level 0 features. Expect the unexpected. # Like that
# All the cool kids use #as#es instead of the letter H now
# "It's a thing" they tell me, but who can be sure
# Holy Syntax Batman !@#$%^&*()|~?":?":?13456780=-=-=\\\

print 'This', 'seems', 'to', 'work'
word1 = 'Yes'
word2 = 'does'
print word1, 'it', word2

print 'Here', 'are', 'all', 'your', 'files,', 'enjoy'
subprocess.call(['ls'])

print 'Here', 'are', 'some', 'files', 'from', 'somewhere', 'else'
os.chdir('/')
subprocess.call(['ls'])
