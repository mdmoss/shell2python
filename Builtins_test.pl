#!/usr/bin/perl
use strict;

use Builtins;
use Test::More 'no_plan';

is (Builtins::echo_to_print ("echo"), "print");
is (Builtins::echo_to_print ("echo 123"), "print 123");
is (Builtins::echo_to_print ('echo $a'), "print a");
is (Builtins::echo_to_print ('echo $a $b 123 $c'), "print a, b, 123, c");
is (Builtins::echo_to_print ("echo abc >>\$file"), "with open(file, 'a') as f: print >>f, 'abc'");
is (Builtins::echo_to_print ("echo -n"), "sys.stdout.write('')");
is (Builtins::echo_to_print ("echo -n 123"), "sys.stdout.write(str(123))");

is (Builtins::echo_to_file ("echo abc >>\$file"), "with open(file, 'a') as f: print >>f, 'abc'");
is (Builtins::echo_to_file ("echo abc >\$file"), "with open(file, 'w') as f: print >>f, 'abc'");
is (Builtins::echo_to_file ("echo abc abc >>file"), "with open('file', 'a') as f: print >>f, 'abc', 'abc'");
is (Builtins::echo_to_file ("echo abc \$var1 \$var2 >\$save"), "with open(save, 'w') as f: print >>f, 'abc', var1, var2");

is (Builtins::echo_to_stdout ("echo -n 123"), "sys.stdout.write(str(123))");
is (Builtins::echo_to_stdout ("echo -n 123 456 \$var"), "sys.stdout.write(str(123) + ' ' + str(456) + ' ' + str(var))");

is (Builtins::cd_to_chdir ("cd /tmp"), "os.chdir('/tmp')");
is (Builtins::cd_to_chdir ("cd /dev"), "os.chdir('/dev')");

is (Builtins::exit_to_exit ("exit 7"), "sys.exit(7)");

is (Builtins::read_to_stdin ("read line"), "line = sys.stdin.readline().rstrip()");

is (Builtins::convert_test ("test matt = great"), "'matt' == 'great'");
is (Builtins::convert_test ('test $number = 9'), "number == 9");
is (Builtins::convert_test ('test -r some/file'), "os.access('some/file', os.R_OK)");
is (Builtins::convert_test ('test -d some/file'), "os.path.isdir('some/file')");
is (Builtins::convert_test ("test 1 -eq \$var"), "1 == int(var)");
is (Builtins::convert_test ("test 1 -ne \$var"), "1 != int(var)");
is (Builtins::convert_test ("test 1 -gt \$var"), "1 > int(var)");
is (Builtins::convert_test ("test 1 -ge \$var"), "1 >= int(var)");
is (Builtins::convert_test ("test 1 -lt \$var"), "1 < int(var)");
is (Builtins::convert_test ("test 1 -le \$var"), "1 <= int(var)");
is (Builtins::convert_test ("test 1 -le 1 -o 2 -ge 2"), "1 <= 1 or 2 >= 2");
is (Builtins::convert_test ("test 1 -le 1 -a 2 -eq 2"), "1 <= 1 and 2 == 2");

is (Builtins::convert_expr ("expr 1 \+ \$var"), '1 + int(var)');
is (Builtins::convert_expr ("expr 1 = 1"), '1 == 1');
is (Builtins::convert_expr ("expr 1 \- \$var"), '1 - int(var)');
is (Builtins::convert_expr ("expr 1 \* \$var"), '1 * int(var)');
is (Builtins::convert_expr ("expr 1 \/ \$var"), '1 / int(var)');
is (Builtins::convert_expr ("expr 1 \% \$var"), '1 % int(var)');
is (Builtins::convert_expr ("expr 1 \+ 2 \+ 3"), '1 + 2 + 3');
is (Builtins::convert_expr ("expr 1 \% \$var \- 4"), '1 % int(var) - 4');
is (Builtins::convert_expr ("expr 1 \% \$var / \$var"), '1 % int(var) / int(var)');

ok (Builtins::can_handle ("echo"));
ok (Builtins::can_handle ("cd"));
is (Builtins::can_handle ("doawesomethingsyeah"), 0);
ok (Builtins::can_handle ("\t\t      echo"));

is (Builtins::handle ("echo 123"), Builtins::echo_to_print ("echo 123"));
is (Builtins::handle ("echo 123 >file"), Builtins::echo_to_print ("echo 123 >file"));
is (Builtins::handle ("exit 999"), Builtins::exit_to_exit ("exit 999"));
is (Builtins::handle ("test matt = great"), Builtins::convert_test ("test matt = great"));
is (Builtins::handle ("expr 1 + 1"), Builtins::convert_expr ("expr 1 + 1"));
