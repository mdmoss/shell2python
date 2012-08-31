#!/usr/bin/perl -w
use strict;

package Flow;

my %keywords;
$keywords{'if'} = "";

sub can_handle {
    # Identifies if this module can handle the line
    my @input = split (/\s/, $_[0]);
    if (defined ($keywords{$input[0]})) {
        return 1;
    } 
    return 0;
}

sub handle {
    # This is the generic entry point for converting a line.
    # Should only be called after can_handle returns true
    my @input = split (/\s/, $_[0]);
    if (defined ($keywords{$input[0]})) {
        return &{$keywords{$input[0]}}($_[0]);
    }
    return $_[0];
}

1;
