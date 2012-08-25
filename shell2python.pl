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

my %imports;
my @python_chunks;

while (my $line = <>) {
    chomp $line;
    if ($line =~ /^#!/ && $. == 1) {
        # This is the shebang. It can be ignored
    } elsif ($line =~ /echo ["'](.*)["']/) {
        push (@python_chunks, "print '$1'\n");
    } elsif ($line =~ /(\w+)\s(.+)/) {
        # We'll assume these lines are executions
        $imports{"subprocess"} = 1;
        push (@python_chunks, "subprocess.call([\"$1\", \"$2\"])\n");

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
