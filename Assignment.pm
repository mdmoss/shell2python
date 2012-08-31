#!/usr/bin/perl -w
use strict;

package Assignment;

sub can_handle {
    # Identifies if this module can handle a line
    return ($_[0] =~ /[a-zA-Z]\w*=.+/);
}

sub handle {
    # This is the generic entry point for converting a line.
    # Should only be called after can_handle returns true
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

sub get_imports {
    return "";
}

1;
