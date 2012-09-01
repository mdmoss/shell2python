#!/usr/bin/perl -w
use strict;

use Translate;
use Test::More 'no_plan';

is (Translate::escape_arg ('$var'), "var");
is (Translate::escape_arg ("confusing"), "'confusing'");
is (Translate::escape_arg ('money$'), "'money\$'");
is (Translate::escape_arg ("'String'"), "'String'");

is (Translate::arguments ('var'), "'var'");
is (Translate::arguments ('var var'), "'var', 'var'");
is (Translate::arguments ('$var'), "var");
is (Translate::arguments ('$var1 $var2'), "var1, var2");
is (Translate::arguments ('str1 $var1 $var2 str2'), "'str1', var1, var2, 'str2'");

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

ok (${Translate::introspect_imports("sys.stdin.read()")}{'sys'});
ok (${Translate::introspect_imports("while sys.stdin.read():")}{'sys'});
ok (${Translate::introspect_imports("subprocess.call('pwd')")}{'subprocess'});
ok (${Translate::introspect_imports("for i in sorted(glob.glob('*.c')):")}{'glob'});
ok (${Translate::introspect_imports("for i in sys.argv[0]")}{'sys'});
