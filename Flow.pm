#!/usr/bin/perl -w
use strict;

use Translate;
use Builtins;
use Command;

package Flow;

my %keywords;
$keywords{'if'} = \&convert_if;
$keywords{'elif'} = \&convert_elif;
$keywords{'for'} = \&convert_for;
$keywords{'while'} = \&convert_while;
$keywords{'else'} = \&convert_else;
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

sub get_indent_delta {
    my $result = 0; 
    $_[0] =~ /(\w+)/;
    if ($1 =~ /^(do|then)$/) {
        $result = 4;
    } elsif ($1 =~ /^(done|fi|elif)$/) {
        $result = -4;
    }
    return $result;
}

sub convert_if {
    my $input = $_[0];
    my $result = "";
    if ($input =~ /if (.*)$/) {
        $result = "if ".convert_condition($1).":";
    }
    return $result;
}

sub convert_elif {
    my $input = $_[0];
    my $result = "";
    if ($input =~ /elif (.*)$/) {
        $result = "elif ".convert_condition($1).":";
    }
    return $result;
}

sub convert_condition {
    if (Builtins::can_handle($_[0])) {
        return Builtins::handle($_[0]);
    }
    return Translate::arguments($_[0]);
}

sub convert_for {
    my $input = $_[0];
    my $result = "";
    if ($input =~ /for (\w+) in (.*)$/) {
        my $variable = $1;
        my $iterables = $2;
        if ($iterables =~ /\*.*/) {
            # This is a special case for the use of " for some reason.
            $result = 'for '.$variable.' in sorted(glob.glob("'.$iterables.'")):';
        } else {
            $result = "for ".$variable." in ".Translate::arguments($iterables).":";
        }
    }
    return $result;
}

sub convert_while {
    my $input = $_[0];
    my $result = "";
    if ($input =~ /while\s+(.*)$/) {
        my $condition = $1;
        if ($condition =~ /^\$/) {
            # It's a variable
            $result = "while ".Translate::arguments($condition).":";
        } elsif (Builtins::can_handle($condition)){
            $result = "while ".Builtins::handle($condition).":"; 
        } else {
            $result = "while not ".Command::handle($condition).":";
        }
    }
    return $result;
}   

sub convert_else {
    return "else:";
}

sub blank {
    return "";
}

1;
