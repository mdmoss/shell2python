#!/usr/bin/perl -w

# Matthew Moss
# mdm@cse.unsw.edu.au
# cs2041, 12s2

use strict;

use Test::Harness;

my @tests = glob ('*_test.pl');
runtests (@tests);
