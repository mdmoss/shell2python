#!/usr/bin/perl
use strict;

use Assignment;
use Test::More 'no_plan';

is (Assignment::can_handle ("abc=1"), 1);
is (Assignment::can_handle ("var = 7"), "");
is (Assignment::can_handle ("v=some expression"), 1);
is (Assignment::can_handle ("1=lalala"), "");
is (Assignment::can_handle ("aa1=123"), 1);

is (Assignment::handle ("variable=hello"), 'variable = "hello"');
is (Assignment::handle ("variable=123"), 'variable = 123');
is (Assignment::handle ("fruit=lemon32"), 'fruit = "lemon32"');
