#!/usr/bin/python2.7 -u
import glob
import os
import subprocess
import sys

# We'll start with a for loop. Everyone likes for loops.

for n in 1, 2, 3:
    name = sys.stdin.readline().rstrip()
    print 'name', n, 'is', name
    subprocess.call(['pwd'])

os.chdir('/')
subprocess.call(['pwd'])

for object in sorted(glob.glob("*")):
    print object
for object in sorted(glob.glob("*.sh")):
    print object
for object in sorted(glob.glob("file.*")):
    print object
for object in sorted(glob.glob("*.[ch]")):
    print object

sys.exit(123)
