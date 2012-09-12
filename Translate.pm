#!/usr/bin/perl -w
use strict;

package Translate;

sub arguments {
    # May need a little refining. Also, add backtics etc
    my $result = "";

    my $args = $_[0];
    $args =~ s/^\s*//;
    
    my $conversion_type = "";
    if (scalar (@_) > 1) {
        # Assume they've passed a conversion type. That's good.
        $conversion_type = $_[1];
    }

    my $separator = ", ";
    if (scalar (@_) > 2) {
        # They've also passed a separator. We can handle that.
        $separator = $_[2];
    }

    while ($args ne "") {
        if ($args =~ /^([^'"\s]+)\s*/) {
            # It's not quoted. The usual escape will do the job
            $result = $result.escape_arg($1, $conversion_type).$separator;
            $args =~ s/^([^'"\s]+)\s*//;
        } elsif ($args =~ /^'((\\'|.)*?)'/) {
            # It's got single quotes. Do it directly
            $result = $result."'".$1."'".$separator;
            $args =~ s/^'(\\'|.)*?'\s*//;
        } elsif ($args =~ /^("((\\"|.)*?)")/) {
            # It's got double quotes. Eventually deal with interpolation here
            $result = $result.interpolate($1).$separator;
            $args =~ s/^"(\\"|.)*?"\s*//;
        } else {
            # This is a worst-case bail out to kill an infinite loop.
            last;
        }
    }
    # Remove trailing whitespace, and possible separator 
    $result =~ s/\s*($separator)?$//;
    return $result;
}

sub interpolate {
    # Replaces any variables present in strings
    my $input = $_[0];
   
    $input =~ s/([^\\])?\$(\w+)/$1" \+ str($2) \+ "/g;
    $input =~ s/ \+ "" //g;
    $input =~ s/^\s*"" \+ //;
    $input =~ s/ \+ ""\s*$//;

    return $input;
}

my %numeric_types = (
'int' => 1,
'float' => 1,
'long' => 1,
'complex' => 1);

sub escape_arg {
    # Removes dollar sign from variables, or adds quotations to strings
    my $input = $_[0];
    my $conversion_type = $_[1];
    if ($input =~ /^\$/) {
        if ($input =~ /^\s*\$(\d+)\s*$/) {
            # It's in argv
            $input = "sys.argv[".$1."]";
        } elsif ($input =~ /^\s*\$\@\s*/){
            # It's all the argvs
           $input = "sys.argv[1:]";
        } elsif ($input =~ /^\s*\$\#\s*/){
            # It's the length of the arg array
            $input = "len(sys.argv[1:])";
        } else {
            if ($conversion_type) {
                $input =~ /^\$(.*)/;
                $input = $conversion_type."(".$1.")";
            } else {
                $input =~ s/^\$//;
            }
        }
    } elsif ($input =~ /^\s*\d+\s*$/ || $input =~ /^\s*-\d+\s*$/) {
        # It's numeric. We should convert it if it isn't already.
        if ($conversion_type && not defined ($numeric_types{$conversion_type})) {
            $input =~ /(\d+)/;
            $input = $conversion_type."(".$1.")";
        }
    } elsif ($input =~ /['"].*['"]/) {
        # It's quoted
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
    if ($input =~ /^[^'"\\\$]*?(#.*)$/) {
        # It's a simple comment. Return it
         return $1;
    }
    $input =~ s/\\\#//g; 
    $input =~ s/\$\#//g; # This is a bit lazy, but I'll fix it later if need be
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
    while ($line =~ /((\w+\.)+)/) {
        my $import = $1;
        $import =~ s/\.$//;
        $import =~ s/sys.stdin/sys/; # Terrible fix for non-standard things
        $imports{$import} = 1; 
        $line =~ s/((\w+\.)+)//;
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

sub remove_quotes {
    # Removes the first and last non-whitespace characters, if they are matching quotes
    if ($_[0] =~ /\s*(['"])((\\\\1|.)*?)\1\s*/) {
        return $2;
    }
    return $_[0];

}

1;
