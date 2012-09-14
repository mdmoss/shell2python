#!/usr/bin/python2.7 -u
import glob
import os
import os.path
import subprocess
import sys

# Prints directories one level deeper than current

for obj in sorted(glob.glob("*")):
    if os.path.isdir(str(obj)):
        sys.stdout.write(str(obj) + ' ' + ": ")
        os.chdir(str(obj))
        subprocess.call(['ls'])
        os.chdir('..')
    else:
        print obj
