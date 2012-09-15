#!/bin/sh

# Nasty things with quotes

echo hello'123'
echo hello"123"hello
echo hello'$q'""
echo '`date`'
echo `date`
echo "`date`"''""''""'hi'
