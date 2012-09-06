#!/usr/bin/perl -w
use strict;

use Translate;

package Builtins;

my %keywords;
$keywords{'echo'} = \&echo_to_print;
$keywords{'exit'} = \&exit_to_exit;
$keywords{'read'} = \&read_to_stdin;
$keywords{'cd'} = \&cd_to_chdir;
$keywords{'test'} = \&convert_test;
#$keywords{'expr'} = 1;

sub can_handle {
    # Identifies if this module can handle the line
    my $input = $_[0];
    $input =~ s/^\s*(\w+)//;
    if (defined ($keywords{$1})) {
        return 1;
    } 
    return 0;
}

sub handle {
    # This is the generic entry point for converting a line.
    # Should only be called after can_handle returns true
    my $input = $_[0];
    $input =~ /^\s*(\w+)/;
    if (defined ($keywords{$1})) {
        return &{$keywords{$1}}($input);
    }
    return $input;
}

sub echo_to_print {
    # Anything with an unescaped $ is a variable. Otherwise, string.    
    my $input = $_[0];
    chomp $input;
    $input =~ s/echo//;
    my $result = "print ".Translate::arguments($input);
    $result =~ s/\s*$//;
    return $result;
}

sub cd_to_chdir {
    my $input = $_[0];
    chomp $input;
    $input =~ s/cd//;
    my $result = "os.chdir(".Translate::arguments($input).")";
    return $result;
}

sub exit_to_exit {
    my $input = $_[0];
    if ($input =~ /exit (\d+)/) {
        return "sys.exit(".$1.")";
    }
    return $input;
}

sub read_to_stdin {
    my $input = $_[0];
    if ($input =~ /read (\w+)/) {
        return $1." = sys.stdin.readline().rstrip()";
    }
    return $input;
}

sub convert_test {
    my $input = $_[0];
    my $result = "";
    if ($input =~ /test -r (\S+)/) {
        $result = "os.access(".Translate::arguments($1).", os.R_OK)";
    } elsif ($input =~ /test -d (\S+)/) {
        $result = "os.path.isdir(".Translate::arguments($1).")";
    } elsif ($input =~ /test (\S+) (\S+) (\S+)/) {
        if ($2 eq "=") {
            $result = Translate::arguments ($1)." == ".Translate::arguments ($3);
        }
    }
    return $result;
}        
1;
