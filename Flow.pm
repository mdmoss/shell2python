#!/usr/bin/perl -w
use strict;

use Translate;

package Flow;

my %keywords;
$keywords{'if'} = "";
$keywords{'for'} = \&convert_for;
$keywords{'do'} = \&blank;
$keywords{'then'} = \&blank;
$keywords{'done'} = \&blank;
$keywords{'fi'} = \&blank;

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

sub get_imports {
    return "";
}

sub get_indent_delta {
    my $result = 0; 
    if ($_[0] =~ /(do|then)\s*$/) {
        $result = 4;
    } elsif ($_[0] =~ /(done|fi)\s*$/) {
        $result = -4;
    }
    return $result;
}

sub convert_for {
    my $input = $_[0];
    my $result = "";
    if ($input =~ /for (\w) in (.*)$/) {
        $result = "for ".$1." in ".Translate::arguments($2).":";
    }
    return $result;
}

sub blank {
    return "";
}

1;
