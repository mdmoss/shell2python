#!/usr/bin/perl -w
use strict;

package Translate;

sub arguments {
    # May need a little refining. Also, add backtics etc

    my $result = "";
    my @arguments = split (/\s+/, $_[0]);
    foreach my $i (0..($#arguments)) {
        next unless ($arguments[$i] ne "");
        $result = $result.escape_arg($arguments[$i]).", "; 
    }
    # Remove trailing whitespace, and possible comma whitespace
    $result =~ s/\s*(,\s*)?$//;
    return $result;
}

sub escape_arg {
    # Removes dollar sign from variables, or adds quotations to strings
    my $input = $_[0];
    if ($input =~ /^\$/) {
        $input =~ s/^\$//;
    } elsif ($input =~ /['"].*['"]/) {
        $input = $input; # No change at this point
    } elsif ($input =~ /['"]/) {
        $input =~ s/['"]//g;
        $input = "'".$input."'";
    } else {
        $input = "'".$input."'";
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
