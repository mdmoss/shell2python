#!/usr/bin/perl -w
use strict;

use Translate;

package Builtins;

my %keywords;
$keywords{'echo'} = \&echo_to_print;
#$keywords{'exit'} = 1;
#$keywords{'read'} = 1;
$keywords{'cd'} = \&cd_to_chdir;
#$keywords{'test'} = 1;
#$keywords{'expr'} = 1;

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

my %imports;
$imports{'cd'} = 'os';

sub get_imports {
    # This returns any imports needed for the conversion of a specific line
    my @input = split (/\s/, $_[0]);
    
    my %result = ();
    
    if (defined ($imports{$input[0]})) {
        $result{$imports{$input[0]}} = 1;
    }  
    
    return \%result;
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
