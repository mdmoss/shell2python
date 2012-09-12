#!/usr/bin/perl -w
use strict;

use Translate;
use Test::More 'no_plan';

is (Translate::escape_arg ('$var'), "var");
is (Translate::escape_arg ("confusing"), "'confusing'");
is (Translate::escape_arg ('money$'), "'money\$'");
is (Translate::escape_arg ("'String'"), "'String'");
is (Translate::escape_arg ('$1'), "sys.argv[1]");
is (Translate::escape_arg ('$@'), "sys.argv[1:]");
is (Translate::escape_arg ('$#'), "len(sys.argv[1:])");
is (Translate::escape_arg ('1'), '1');
is (Translate::escape_arg ('2'), '2');
is (Translate::escape_arg ('-1'), '-1');
is (Translate::escape_arg ('-300'), '-300');

is (Translate::arguments ('var'), "'var'");
is (Translate::arguments ('var var'), "'var', 'var'");
is (Translate::arguments ('$var'), "var");
is (Translate::arguments ('$var1 $var2'), "var1, var2");
is (Translate::arguments ('str1 $var1 $var2 str2'), "'str1', var1, var2, 'str2'");
is (Translate::arguments ('123'), 123);
is (Translate::arguments ('123 hi'), "123, 'hi'");
is (Translate::arguments ("'words words words'"), "'words words words'");
is (Translate::arguments ('$#'), "len(sys.argv[1:])"); 
is (Translate::arguments ('"$var"'), "str(var)"); 
is (Translate::arguments ('"some $value"'), '"some " + str(value)'); 
is (Translate::arguments ('"some $value in middle"'), '"some " + str(value) + " in middle"'); 

# Testing the convert type passing thing. Function prototypes would be nice here.
is (Translate::arguments ('$var', 'str'), "str(var)");
is (Translate::arguments ('$var', 'int'), "int(var)");
is (Translate::arguments ('$var $var', 'int'), "int(var), int(var)");
is (Translate::arguments ('123', 'int'), "123");
is (Translate::arguments ('123', 'long'), "123");
is (Translate::arguments ('123', 'float'), "123");
is (Translate::arguments ('123', 'complex'), "123");
is (Translate::arguments ('123', 'str'), "str(123)");

# Test specifying the seperator. Really missing that structured programming
is (Translate::arguments ('abc def', 'str', 'word'), "'abc'word'def'");
is (Translate::arguments ('$var $var', 'str', 'word'), "str(var)wordstr(var)");
is (Translate::arguments ('$var $var', 'str', ' and '), "str(var) and str(var)");

is (Translate::interpolate ('"$var"'), "str(var)");
is (Translate::interpolate ('"$var and one"'), 'str(var) + " and one"');

is (Translate::get_comment ("#comment"), "#comment");
is (Translate::get_comment ("no comment"), "");
is (Translate::get_comment ("no comment #comment"), "#comment");
is (Translate::get_comment ("no comment#comment"), "#comment");
is (Translate::get_comment ("'no # comment'"), "");
is (Translate::get_comment ('"#no comment"'), "");
is (Translate::get_comment ("no \\# comment"), "");
is (Translate::get_comment ("'#comment"), "#comment");
is (Translate::get_comment ("#comment''"), "#comment''");
is (Translate::get_comment ("#!/usr/bin/perl"), "#!/usr/bin/perl");
is (Translate::get_comment ('$#'), "");

is (Translate::strip_first_quote ('"test"123'), "123");
is (Translate::strip_first_quote ('"test""123"'), '"123"');
is (Translate::strip_first_quote ("'test'123"), "123");
is (Translate::strip_first_quote ("'test''123'"), "'123'");
is (Translate::strip_first_quote ("'it\\'s amazing'"), "");

is (Translate::strip_quotes ("'this is quoted'"), "");
is (Translate::strip_quotes ("a'q'b'q'c'q'"), "abc");
is (Translate::strip_quotes ("'quote\"quote\"quote'"), "");
is (Translate::strip_quotes ('"quote\'quote\'quote"'), "");
is (Translate::strip_quotes ('"quote""quote"\'quote\''), "");

is (Translate::remove_quotes ("'*'"), "*");
is (Translate::remove_quotes ("'a'"), "a");
is (Translate::remove_quotes ("'123'"), "123");
is (Translate::remove_quotes ("'123123123'"), "123123123");
is (Translate::remove_quotes ("'/'"), "/");

ok (${Translate::introspect_imports("sys.stdin.read()")}{'sys'});
ok (${Translate::introspect_imports("while sys.stdin.read():")}{'sys'});
ok (${Translate::introspect_imports("subprocess.call('pwd')")}{'subprocess'});
ok (${Translate::introspect_imports("for i in sorted(glob.glob('*.c')):")}{'glob'});
ok (${Translate::introspect_imports("for i in sys.argv[0]")}{'sys'});
