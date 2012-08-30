#!/usr/bin/perl
use strict;

use Builtins;

package Assignment;

sub translate {
    # Handles assignments, both strings and numerics

    my $input = $_[0];
    chomp ($input);

    $input =~ /(\w+)=.+/;
    my $variable = $1;

    my $value;
    if ($input =~ /\w+=(\d+)$/) {
        # It's a pure numeric. Assume a number.
        $value = $1; 
    } else {
        # It's mixed. A string will do.
        $input =~ /\w+=(\w+)$/;
        $value = '"'.$1.'"';
    }

    return "$variable = $value";
}   

1;
