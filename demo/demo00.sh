#!/bin/sh

# Easy diary - outputs the current time and arguments to a file

echo `date`: $@ >> log.txt

