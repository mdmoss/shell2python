#!/usr/bin/perl -w
use strict;

use Test::Harness;

my @tests = glob ('*_test.pl');
runtests (@tests);
