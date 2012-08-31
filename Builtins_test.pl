#!/usr/bin/perl
use strict;

use Builtins;
use Test::More 'no_plan';

is (Builtins::echo_to_print ("echo"), "print");
is (Builtins::echo_to_print ("echo 123"), "print '123'");
is (Builtins::echo_to_print ('echo $a'), "print a");
is (Builtins::echo_to_print ('echo $a $b 123 $c'), "print a, b, '123', c");

is (Builtins::cd_to_chdir ("cd /tmp"), "os.chdir('/tmp')");
is (Builtins::cd_to_chdir ("cd /dev"), "os.chdir('/dev')");

ok (Builtins::can_handle ("echo"));
ok (Builtins::can_handle ("cd"));
is (Builtins::can_handle ("doawesomethingsyeah"), 0);
ok (Builtins::can_handle ("\t\t      echo"));

is (Builtins::handle ("echo 123"), Builtins::echo_to_print ("echo 123"));


