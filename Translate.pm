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
        if ($input =~ /^\s*\$(\d+)\s*$/) {
            # It's in argv
            $input = "sys.argv[".$1."]";
        } else {
            $input =~ s/^\$//;
        }
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

sub introspect_imports {
    # Attempts to identify any modules that need importing in a line.
    # Returns these modules as the keys of a hash
    my $line = $_[0];
    $line = strip_quotes($line);
    my %imports = ();
    while ($line =~ /\s*(\w+)\./) {
        $imports{$1} = 1; 
        $line =~ s/$1\.\S*//;
    }
    return \%imports;
}

sub strip_quotes {
    # Returns the input without any quoted sections 
    my $string = $_[0];
    $string =~ s/(["'])(?:\\\1|.)*?\1//g;
    return $string;
}

sub strip_first_quote {
    # Returns the string with the first quoted section stripped

    #
    # There's a great article on this regex at
    # http://blog.stevenlevithan.com/archives/match-quoted-string
    # His solution was elegant enough to replace four lines of mine,
    # so I've used it here.
    #

    my $string = $_[0];
    $string =~ s/(["'])(?:\\\1|.)*?\1//;
    return $string;
}

1;
