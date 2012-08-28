#!/usr/bin/perl -w
use strict;

use CommandSplit;
use Test::More tests => 3;

is (CommandSplit::to_py_list ("ls"), "['ls']");
is (CommandSplit::to_py_list ("ls -l"), "['ls', '-l']");
is (CommandSplit::to_py_list ("ls -l /tmp/"), "['ls', '-l', '/tmp/']");
