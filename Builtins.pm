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
    my $result = "";
    if ($input =~ />\S+\s*$/) {
        # There's stream redirection. Write to file instead
        $result = echo_to_file ($input);
    } else {
        $input =~ s/echo//;
        $result = "print ".Translate::arguments($input);
    }
    $result =~ s/\s*$//;
    return $result;
}

my %file_types;
$file_types{'>>'} = "'a'";
$file_types{'>'} = "'w'";

sub echo_to_file {
    # We can only handle a single destination, so we'll assume it's the last one that appears
    my $input = $_[0];
    $input =~ s/(>>?)(\S+)\s*$//;
    my $attrs = $1;
    my $file = $2;

    # Remove the initial echo 
    $input =~ s/echo//;

    my $result = "with open(".Translate::arguments($file).", ".$file_types{$attrs}.") as f: print >>f, ".Translate::arguments($input);
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

sub convert_test_expression {
    my $input = $_[0];
    my $result = "";
    if ($input =~ /-r (\S+)/) {
        $result = "os.access(".Translate::arguments($1, "str").", os.R_OK)";
    } elsif ($input =~ /-d (\S+)/) {
        $result = "os.path.isdir(".Translate::arguments($1, "str").")";
    } elsif ($input =~ /(\S+) (\S+) (\S+)/) {
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

my %test_seperators;
$test_seperators{'-o'} = 'or';
$test_seperators{'-a'} = 'and';

sub convert_test {
    my $input = $_[0];
    $input =~ s/test\s+//;
    # We now have one or more expressions, seperated by [-o|-a];
    my $result = "";
    while ($input =~ /\s*(.*?)\s*(-a|-o)/) {
        my $seperator = $2;
        $result = $result.convert_test_expression($1)." ".$test_seperators{$seperator}." "; 
        $input =~ s/\s*(.*?)\s*(-a|-o)//; 
    }
    $result = $result.convert_test_expression($input);
    return $result;

}

my %expr_ops;
$expr_ops{'='} = '==';
$expr_ops{'|'} = 'or';
$expr_ops{'&'} = 'and';

sub convert_expr {
    my $input = $_[0];

    # Crop the expr
    $input =~ s/expr\s+//;

    # Process the first element - this should always be a value
    $input =~ s/(\S+)\s+//;
    my $result = Translate::arguments($1, "int");

    while ($input =~ /(\S+)\s+(\S+)/) {
        my $operation = $1;
        my $value = $2;

        if (defined ($expr_ops{$value})) {
            $result = $result." ".$expr_ops{Translate::remove_quotes($operation)};
        } else {
            $result = $result." ".Translate::remove_quotes($operation);
        }
        $result = $result." ".Translate::arguments($value, "int");
    
        $input =~ s/\S+\s+\S+//;
    }
    return $result;
}
1;
