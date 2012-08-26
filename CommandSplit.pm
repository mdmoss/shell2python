#!/usr/bin/perl -w
use strict;

package CommandSplit;

sub to_py_list {
    # Converts a line of shell to a python list, ready to be called by subprocess
    my $shell_line = $_[0];
    chomp ($shell_line);
    unless ($shell_line =~ /[\\'"]/) {
        # There's no tricky syntax going on. Should be ok to break naively.
        my @py_list = split (/\s/, $shell_line);
        my $result = "[";
        foreach my $i (0..($#py_list - 1)) {
            $result = $result."'".$py_list[$i]."'".", "; 
        }
        # The last is a special case
        $result = $result."'".$py_list[$#py_list]."']"; 
        return $result;
    }

    return $shell_line;
}

sub to_py_list_test {
    print to_py_list ("ls");
    print "\n['ls']\n";

    print to_py_list ("ls -l");
    print "\n['ls', '-l']\n";

    print to_py_list ("ls -l /tmp/");
    print "\n['ls', '-l', '/tmp/']\n";
}

1;
