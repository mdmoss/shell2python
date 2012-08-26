#!/usr/bin/perl -w
use strict;

use CommandSplit;
use Test::Simple tests => 3;

ok (CommandSplit::to_py_list ("ls"), "['ls']");

ok (CommandSplit::to_py_list ("ls -l"),"['ls', '-l']");

ok (CommandSplit::to_py_list ("ls -l /tmp/"), "['ls', '-l', '/tmp/']");
