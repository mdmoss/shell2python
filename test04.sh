#!/bin/sh

# Matthew Moss
# mdm@cse.unsw.edu.au
# cs2041, 12s2


# Nasty things with quotes

echo hello'123'
echo hello"123"hello
echo hello'$q'""
echo '`date`'
echo `date`
echo "`date`"''""''""'hi'
