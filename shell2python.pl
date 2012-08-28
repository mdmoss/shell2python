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
    } elsif ($line =~ /^\s*#(.*)/) {
        # This is a comment. We'll replicate it exactly
        push (@python_chunks, "#".$1); 
    } elsif ($line =~ /echo.*/) {
        push (@python_chunks, Builtins::echo_to_print ($line)."\n");
    } elsif ($line =~ /\w+=\w+$/) {
        push (@python_chunks, Assignment::translate ($line)."\n");
    } elsif ($line =~ /\w+/) {
        # We'll assume these lines are executions
        $imports{"subprocess"} = 1;
        push (@python_chunks, "subprocess.call(".CommandSplit::to_py_list ($line).")\n");
    } else {
        push (@python_chunks, "#".$line);
    }
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
