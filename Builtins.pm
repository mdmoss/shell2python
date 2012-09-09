#!/usr/bin/perl -w
use strict;

use Translate;

package Builtins;

my %keywords;
$keywords{'echo'} = \&echo_to_print;
$keywords{'exit'} = \&exit_to_exit;
$keywords{'read'} = \&read_to_stdin;
$keywords{'cd'} = \&cd_to_chdir;
$keywords{'test'} = \&convert_test;
$keywords{'expr'} = \&convert_expr;

sub can_handle {
    # Identifies if this module can handle the line
    my $input = $_[0];
    if ($input =~ /^\s*\`/) {
        # It's a backticked expression. Better handle it.
        return 1;
    }
    $input =~ /^\s*(\w+)/;
    if (defined ($keywords{$1})) {
        return 1;
    } 

    return 0;
}

sub handle {
    # This is the generic entry point for converting a line.
    # Should only be called after can_handle returns true
    my $input = $_[0];
    $input =~ /^\s*(\w+)/;
    if ($input =~ /^\s*\`/) {
        # It's a backticked expression. Better handle it.
        return convert_backticks($input);
    }
    if (defined ($keywords{$1})) {
        return &{$keywords{$1}}($input);
    }

    return $input;
}

sub convert_backticks {
    my $input = $_[0];
    $input =~ /^\s*\`(.*?)\`\s*$/;
    my $expression = $1;
    if (can_handle ($expression)) {
        return handle ($expression);
    }
    return $expression;
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
    my $result = "os.chdir(".Translate::arguments($input, "str").")";
    return $result;
}

sub exit_to_exit {
    my $input = $_[0];
    if ($input =~ /exit (\d+)/) {
        return "sys.exit(".$1.")";
    }
    return $input;
}

sub read_to_stdin {
    my $input = $_[0];
    if ($input =~ /read (\w+)/) {
        return $1." = sys.stdin.readline().rstrip()";
    }
    return $input;
}

sub make_non_numeric_int {

    my $input = $_[0];
    unless ($input =~ /^\s*\d*\s*$/) {
        $input =~ s/(.*)/int\($1\)/;
    }
    return $input;
}

my %numeric_tests;
$numeric_tests{'-eq'} = '==';
$numeric_tests{'-ne'} = '!=';
$numeric_tests{'-gt'} = '>';
$numeric_tests{'-ge'} = '>=';
$numeric_tests{'-lt'} = '<';
$numeric_tests{'-le'} = '<=';

sub convert_test {
    my $input = $_[0];
    my $result = "";
    if ($input =~ /test -r (\S+)/) {
        $result = "os.access(".Translate::arguments($1, "str").", os.R_OK)";
    } elsif ($input =~ /test -d (\S+)/) {
        $result = "os.path.isdir(".Translate::arguments($1, "str").")";
    } elsif ($input =~ /test (\S+) (\S+) (\S+)/) {
        my $lhs = $1;
        my $rhs = $3;
        if ($2 eq "=") {
            $result = Translate::arguments ($lhs)." == ".Translate::arguments ($rhs);
        } elsif (defined ($numeric_tests{$2})) {
            $lhs = Translate::arguments($lhs, "int");
            $rhs = Translate::arguments($rhs, "int");
            $result = $lhs." ".$numeric_tests{$2}." ".$rhs;
        }
    }
    return $result;
}

my %numeric_expr_ops;
$numeric_expr_ops{'+'} = '+';
$numeric_expr_ops{'-'} = '-';
$numeric_expr_ops{'*'} = '*';
$numeric_expr_ops{'/'} = '/';
$numeric_expr_ops{'<'} = '<';
$numeric_expr_ops{'<='} = '<=';
$numeric_expr_ops{'='} = '==';
$numeric_expr_ops{'!='} = '!=';
$numeric_expr_ops{'>='} = '>=';
$numeric_expr_ops{'>'} = '>';
$numeric_expr_ops{'%'} = '%';

my %logical_expr_ops;
$logical_expr_ops{'|'} = 'or';
$logical_expr_ops{'&'} = 'and';

sub convert_expr {
    my $input = $_[0];
    my $result = "";
    if ($input =~ /expr (\S+) (\S+) (\S+)/) {
        my $lhs = $1;
        my $operation = $2;  
        my $rhs = $3;
        $operation =~ s/\\//g;
        if (defined ($numeric_expr_ops{$operation})) {
            $lhs = make_non_numeric_int (Translate::arguments($lhs));
            $rhs = make_non_numeric_int (Translate::arguments($rhs));
            $result = $lhs." ".$numeric_expr_ops{$operation}." ".$rhs;
        } elsif (defined ($logical_expr_ops{$operation})) {
            $result = Translate::arguments ($lhs)." ".$numeric_expr_ops{$operation}." ".Translate::arguments($rhs);
        }
    }
    return $result;
}
1;
