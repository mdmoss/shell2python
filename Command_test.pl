#!/usr/bin/perl -w
use strict;

use Command;
use Test::More 'no_plan';

ok (Command::can_handle('pwd'));

is (Command::handle('pwd'), "subprocess.call(['pwd'])");
is (Command::handle('ls -l /tmp'), "subprocess.call(['ls', '-l', '/tmp'])");

my %imports = %{Command::get_imports('pwd')};
ok ($imports{'subprocess'});
