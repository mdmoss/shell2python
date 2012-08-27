#!/usr/bin/perl
use strict;

use Builtins;
use Test::Simple tests => 8;

ok (Builtins::escape_echo_arg ('$var'), "var");
ok (Builtins::escape_echo_arg ("confusing"), '"confusing"');
ok (Builtins::escape_echo_arg ('money$'), '"money$"');
ok (Builtins::escape_echo_arg ('"String"'), '"String"');

ok (Builtins::echo_to_print ("echo"), "print");
ok (Builtins::echo_to_print ("echo 123"), 'print "123"');
ok (Builtins::echo_to_print ('echo $a'), "print a");
ok (Builtins::echo_to_print ('echo $a $b 123 $c'), 'print a, b, "123", c');

