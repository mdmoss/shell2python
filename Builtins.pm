#!/usr/bin/perl
use strict;

package Builtins;

my %builtins;
$builtins{'echo'} = \&echo_to_print;
#$builtins{'exit'} = 1;
#$builtins{'read'} = 1;
$builtins{cd} = \&cd_to_chdir;
#$builtins{'test'} = 1;
#$builtins{'expr'} = 1;

sub can_handle {
    # This function will identify if this module can handle the code
    my @input = split (/\s/, $_[0]);
    if (defined ($builtins{$input[0]})) {
        return 1;
    } 
    return 0;
}

sub handle {
    # This is the generic entry point for converting a builtin function
    my @input = split (/\s/, $_[0]);
    if (defined ($builtins{$input[0]})) {
        return &{$builtins{$input[0]}}($_[0])
    }
    return $_[0];
}

sub echo_to_print {
    # Anything with an unescaped $ is a variable. Otherwise, string.    
    my $input = $_[0];
    chomp $input;
    $input =~ s/echo//;
    my $result = "print ".translate_args($input);
    $result =~ s/\s*$//;
    return $result;
}

sub cd_to_chdir {
    my $input = $_[0];
    chomp $input;
    $input =~ s/cd//;
    my $result = "os.chdir(".translate_args($input).")";
    return $result;
}

sub translate_args {
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
