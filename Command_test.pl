#!/usr/bin/perl -w
use strict;

use Command;
use Test::More 'no_plan';

ok (Command::can_handle('pwd'));
ok (Command::can_handle('ls'));

is (Command::handle('pwd'), "subprocess.call(['pwd'])");
is (Command::handle('ls -l /tmp'), "subprocess.call(['ls', '-l', '/tmp'])");
is (Command::handle('ls -las "$@"'), "subprocess.call(['ls', '-las']+sys.argv[1:])");

