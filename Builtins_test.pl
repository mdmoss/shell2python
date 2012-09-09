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

is (Builtins::convert_test ("test matt = great"), "'matt' == 'great'");
is (Builtins::convert_test ('test $number = 9'), "str(number) == 9");
is (Builtins::convert_test ('test -r some/file'), "os.access('some/file', os.R_OK)");
is (Builtins::convert_test ('test -d some/file'), "os.path.isdir('some/file')");
is (Builtins::convert_test ("test 1 -eq \$var"), "1 == int(var)");
is (Builtins::convert_test ("test 1 -ne \$var"), "1 != int(var)");
is (Builtins::convert_test ("test 1 -gt \$var"), "1 > int(var)");
is (Builtins::convert_test ("test 1 -ge \$var"), "1 >= int(var)");
is (Builtins::convert_test ("test 1 -lt \$var"), "1 < int(var)");
is (Builtins::convert_test ("test 1 -le \$var"), "1 <= int(var)");

is (Builtins::convert_expr ("expr 1 \+ \$var"), '1 + int(var)');
is (Builtins::convert_expr ("expr 1 \- \$var"), '1 - int(var)');
is (Builtins::convert_expr ("expr 1 \* \$var"), '1 * int(var)');
is (Builtins::convert_expr ("expr 1 \/ \$var"), '1 / int(var)');
is (Builtins::convert_expr ("expr 1 \% \$var"), '1 % int(var)');

ok (Builtins::can_handle ("echo"));
ok (Builtins::can_handle ("cd"));
is (Builtins::can_handle ("doawesomethingsyeah"), 0);
ok (Builtins::can_handle ("\t\t      echo"));

is (Builtins::handle ("echo 123"), Builtins::echo_to_print ("echo 123"));
is (Builtins::handle ("exit 999"), Builtins::exit_to_exit ("exit 999"));
is (Builtins::handle ("test matt = great"), Builtins::convert_test ("test matt = great"));
