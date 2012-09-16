#!/usr/bin/perl -w

# Matthew Moss
# mdm@cse.unsw.edu.au
# cs2041, 12s2

use strict;

use Assignment;
use Flow;
use Builtins;
use Command;

my %imports;
# $indent is used for multi line tracking, $temp_indent is reset for every line read.
my $indent = 0;
my $temp_indent = 0;
my @python_chunks;
# Tracks state of switch / case
my $switch_case_var = "";;

while (my $line = <>) {
    chomp $line;
    
    if ($line =~ /^#!/ && $. == 1) {
        # This is the shebang. It can be ignored
        next
    }
    
    my $comment = Translate::get_comment($line);
    if ($comment eq $line) { # The whole line is a comment
        push (@python_chunks, $comment."\n");
        next
    }

    $line =~ s/\Q$comment\E//; 
    $line =~ s/^\s*//;
    $line =~ s/\s*$//;
    
    $temp_indent = 0;

    # Last minute switch / case handling
    # Unfortunately, this has to be stateful, so can't fit easily into the flow module.
    # Having a special case is neater than hacking it in, IMHO.

    if ($line =~ /^case (\S+) in/) {
        $switch_case_var = Translate::arguments($1);
        $line =~ s/^case \S+ in//;
    }

    if ($switch_case_var ne "" and $line =~ /^(\S+)[^\\]*\)/) {
        push (@python_chunks, " "x$indent."if ".$switch_case_var." == ".Translate::arguments($1).":\n");
        $line =~ s/^(\S+)[^\\]*\)//;
        $indent += 4;
    }

    if ($switch_case_var and $line =~ /\;\;$/) {
        $temp_indent += 4; 
        $indent -= 4;
        $line =~ s/;;$//;
    }

    if ($switch_case_var ne "" and $line =~ /esac/) {
        $switch_case_var = "";
        $line =~ s/esac//;
    }

    # This regex matches any shell line followed by a metacharacter. Eg expr; expr && expr||
    while ($line =~ /(?:((?:(['"]).*?\2|\\;|\\\|\||\\&&|.)+?)(;|\|\||&&|$))\s*/) {
        
        my $expression = $1;
        my $separator = $3;

        my $python = convert_expression($expression);
        my $line_imports = Translate::introspect_imports($python);

        $indent += Flow::get_indent_delta($expression);
        $python = $python."  ".$comment;  # Note double space as per PEP-8
        $python =~ s/\s*$//;

        if ($python =~ /else:/) {
            # This is a shameful workaround, but should do the job.
            push (@python_chunks, " "x($indent-4 + $temp_indent).$python."\n");
        } elsif ($separator =~ /\&\&/) {
            push (@python_chunks, " "x($indent + $temp_indent)."if ".$python.":\n");
            $temp_indent += 4; 
        } elsif ($separator =~ /\|\|/) {
            push (@python_chunks, " "x($indent + $temp_indent)."if not ".$python.":\n");
            $temp_indent += 4; 
        } elsif ($python) {
            push (@python_chunks, " "x($indent + $temp_indent).$python."\n");
        }

        if ($line_imports ne "") {
            @imports {keys %{$line_imports}} = values %{$line_imports};
        }

        $line =~ s/(?:((?:(['"]).*?\2|\\;|\\\|\||\\&&|.)+?)(;|\|\||&&|$))\s*//;
    }

}

# Begin outputting the final result

# We're targeting python 2.7, so it makes sense to always use it
print "#!/usr/bin/python2.7 -u\n";

foreach my $import (sort (keys %imports)) {
    print "import $import\n";
}

foreach my $line (@python_chunks) {
    print $line;
}

sub convert_expression {

    my $line = $_[0];
    my $python;

    if (Assignment::can_handle($line)) {
        # printf ("Handled by Assignment\n");
        $python =  Assignment::handle ($line);
        
    } elsif (Flow::can_handle($line)) {
        # printf ("Handled by Flow\n");
        $python =  Flow::handle ($line);
        
    } elsif (Builtins::can_handle($line)) {
        # printf ("Handled by Builtins\n");
        $python =  Builtins::handle ($line);
        
    } elsif (Command::can_handle($line)) {
        # printf ("Handled by Command\n");
        $python =  Command::handle ($line);
    } else {
        $python = "#_no_trans_# ".$line;
    }

    return $python;
}
