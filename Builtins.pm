#!/usr/bin/perl
use strict;

package Builtins;

my %builtins;
$builtins['echo'] = 1;
$builtins['exit'] = 1;
$builtins['read'] = 1;
$builtins['cd'] = 1;
$builtins['test'] = 1;
$builtins['expr'] = 1;

sub can_handle {
    # This function will identify if this module can handle the code
    my @input = split (/\s/, $_[0]);
    if (defined $builtins[$input[0]]) {

        return 1;
    } 
    return 0;
}

sub echo_to_print {
    # Anything with an unescaped $ is a variable. Otherwise, string.    
    my $input = $_[0];
    chomp $input;

    my $result = "print ";

    my @arguments = split (/\s/, $input);
    # We assume the first argument is the echo command
    for my $i (1..($#arguments)) {
        $result = $result.escape_echo_arg($arguments[$i]).", "; 
    }
    # Remove trailing whitespace, and possible comma whitespace
    $result =~ s/\s*(,\s*)?$//;
    return $result;
}

sub escape_echo_arg {
    # Removes dollar sign from variables, or adds quotations to strings
    my $input = $_[0];
    if ($input =~ /^\$/) {
        $input =~ s/^\$//;
    } elsif ($input =~ /['"].*['"]/) {
        $input = $input; # No change at this point
    } elsif ($input =~ /['"]/) {
        $input =~ s/['"]//g;
        $input = '"'.$input.'"';
    } else {
        $input = '"'.$input.'"';
    }   
    return $input;    
}

sub get_comment {
    # Returns any comments present in a string
    my $input = $_[0];
    if ($input =~ /^[^'"\\]*?(#.*)$/) {
        # It's a simple comment. Return it
         return $1;
    }
    $input =~ s/\\#//g; 
    # Strip all matched quotes and strings from start string
    while ($input =~ /([^#]|\\#)*(['"]).*?\2/) {
        $input =~ s/(['"])[^\1]*\1//;
    }
    $input =~ s/(['"]).*?\1//g;
    $input =~ s/^[^#]*//;

    return $input;
}

1;
