#!/usr/bin/perl -w
use strict;

use Translate;

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

    $input =~ /(\w+)=(.+)/;
    my $variable = $1;
    my $rhs = $2;
    my $value = "";

    if ($rhs =~ /^\s*\d+\s*$/) {
        # It's a pure numeric
        $value = $rhs;
    } else {
        $value = Translate::escape_arg($2);
    }

    return "$variable = $value";
}

1;
