#!/usr/bin/perl
use strict;

use Builtins;
use Test::More 'no_plan';

is (Builtins::echo_to_print ("echo"), "print");
is (Builtins::echo_to_print ("echo 123"), "print 123");
is (Builtins::echo_to_print ('echo $a'), "print a");
is (Builtins::echo_to_print ('echo $a $b 123 $c'), "print a, b, 123, c");

is (Builtins::cd_to_chdir ("cd /tmp"), "os.chdir('/tmp')");
is (Builtins::cd_to_chdir ("cd /dev"), "os.chdir('/dev')");

is (Builtins::exit_to_exit ("exit 7"), "sys.exit(7)");

is (Builtins::read_to_stdin ("read line"), "line = sys.stdin.readline().rstrip()");

is (Builtins::test_to_equals ("test matt = great"), "'matt' == 'great'");
is (Builtins::test_to_equals ('test $number = 9'), "number == 9");

ok (Builtins::can_handle ("echo"));
ok (Builtins::can_handle ("cd"));
is (Builtins::can_handle ("doawesomethingsyeah"), 0);
ok (Builtins::can_handle ("\t\t      echo"));

is (Builtins::handle ("echo 123"), Builtins::echo_to_print ("echo 123"));
is (Builtins::handle ("exit 999"), Builtins::exit_to_exit ("exit 999"));
is (Builtins::handle ("test matt = great"), Builtins::test_to_equals ("test matt = great")); 
