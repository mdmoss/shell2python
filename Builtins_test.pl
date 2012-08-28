#!/usr/bin/perl
use strict;

use Builtins;
use Test::More tests => 17;

is (Builtins::escape_echo_arg ('$var'), "var");
is (Builtins::escape_echo_arg ("confusing"), '"confusing"');
is (Builtins::escape_echo_arg ('money$'), '"money$"');
is (Builtins::escape_echo_arg ('"String"'), '"String"');

is (Builtins::echo_to_print ("echo"), "print");
is (Builtins::echo_to_print ("echo 123"), 'print "123"');
is (Builtins::echo_to_print ('echo $a'), "print a");
is (Builtins::echo_to_print ('echo $a $b 123 $c'), 'print a, b, "123", c');

is (Builtins::get_comment ("#comment"), "#comment");
is (Builtins::get_comment ("no comment"), "");
is (Builtins::get_comment ("no comment #comment"), "#comment");
is (Builtins::get_comment ("no comment#comment"), "#comment");
is (Builtins::get_comment ("'no # comment'"), "");
is (Builtins::get_comment ('"#no comment"'), "");
is (Builtins::get_comment ("no /# comment"), "");
is (Builtins::get_comment ("'#comment"), "#comment");
is (Builtins::get_comment ("#comment''"), "#comment''");
