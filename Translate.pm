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

1;
