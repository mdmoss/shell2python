#!/usr/bin/perl
use strict;

use Assignment;
use Test::Simple tests => 3;

ok (Assignment::translate ("variable=hello"), 'variable = "hello"');
ok (Assignment::translate ("variable=123"), 'variable = 123');
ok (Assignment::translate ("fruit=lemon32"), 'fruit = "lemon32"');
