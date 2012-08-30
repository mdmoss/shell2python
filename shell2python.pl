#!/usr/bin/perl -w

# Matthew Moss
# mdm@cse.unsw.edu.au
# cs2041, 12s1

# Based on code by Andrew Taylor
# See original header below

# # written by andrewt@cse.unsw.edu.au March 2011
# # as a starting point for COMP2041/9041 assignment 
# # http://cgi.cse.unsw.edu.au/~cs2041/12s2/assignment/shell2python

use strict;

require Builtins;
require CommandSplit;
require Assignment;

my %imports;
my @python_chunks;

while (my $line = <>) {
    chomp $line;
    if ($line =~ /^#!/ && $. == 1) {
        # This is the shebang. It can be ignored
        next
    } 
    
    my $comment = Builtins::get_comment($line);
    if ($comment eq $line) { # The whole line is a comment
        push (@python_chunks, $comment."\n");
        next
    }
    $line =~ s/$comment//;    

    if (Builtins::can_handle($line)) {
        push (@python_chunks, Builtins::handle ($line));
        if (Builtins::get_import ($line) ne '') {
            $imports{Builtins::get_import{$line}} = 1;
        }   
    } elsif ($line =~ /\w+=\w+$/) {
        push (@python_chunks, Assignment::translate ($line));
    } elsif ($line =~ /\w+/) {
        # We'll assume these lines are executions
        $imports{"subprocess"} = 1;
        push (@python_chunks, "subprocess.call(".CommandSplit::to_py_list ($line).")");
    } else {
        push (@python_chunks, "#".$line);
    }

    push (@python_chunks, " ".$comment."\n");
}

# Begin outputting the final result

# We're targeting python 2.7, so it makes sense to always use it
print "#!/usr/bin/python2.7\n";

foreach my $import (keys %imports) {
    print "import $import\n";
}

foreach my $line (@python_chunks) {
    print $line;
}
