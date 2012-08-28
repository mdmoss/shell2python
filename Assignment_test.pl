#!/usr/bin/perl
use strict;

use Assignment;
use Test::More tests => 3;

is (Assignment::translate ("variable=hello"), 'variable = "hello"');
is (Assignment::translate ("variable=123"), 'variable = 123');
is (Assignment::translate ("fruit=lemon32"), 'fruit = "lemon32"');
