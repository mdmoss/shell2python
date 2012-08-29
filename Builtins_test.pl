#!/usr/bin/perl
use strict;

use Builtins;
use Test::More 'no_plan';

is (Builtins::escape_arg ('$var'), "var");
is (Builtins::escape_arg ("confusing"), "'confusing'");
is (Builtins::escape_arg ('money$'), "'money\$'");
is (Builtins::escape_arg ("'String'"), "'String'");

is (Builtins::echo_to_print ("echo"), "print");
is (Builtins::echo_to_print ("echo 123"), "print '123'");
is (Builtins::echo_to_print ('echo $a'), "print a");
is (Builtins::echo_to_print ('echo $a $b 123 $c'), "print a, b, '123', c");

is (Builtins::cd_to_chdir ("cd /tmp"), "os.chdir('/tmp')");
is (Builtins::cd_to_chdir ("cd /dev"), "os.chdir('/dev')");

is (Builtins::get_comment ("#comment"), "#comment");
is (Builtins::get_comment ("no comment"), "");
is (Builtins::get_comment ("no comment #comment"), "#comment");
is (Builtins::get_comment ("no comment#comment"), "#comment");
is (Builtins::get_comment ("'no # comment'"), "");
is (Builtins::get_comment ('"#no comment"'), "");
is (Builtins::get_comment ("no \\# comment"), "");
is (Builtins::get_comment ("'#comment"), "#comment");
is (Builtins::get_comment ("#comment''"), "#comment''");

ok (Builtins::can_handle ("echo"));
ok (Builtins::can_handle ("cd"));
is (Builtins::can_handle ("doawesomethingsyeah"), 0);

is (Builtins::handle ("echo 123"), Builtins::echo_to_print ("echo 123"));
