#!/usr/bin/perl -w

# Matthew Moss
# mdm@cse.unsw.edu.au
# cs2041, 12s2

use strict;

use Translate;

package Command;

sub can_handle {
    # Identifies if this module can handle a line
    # We can always execute arbitrary commands, even invalid ones
    # This module is effectively a catch-all
    return (1);
}

sub handle {
    # This is the generic entry point for converting a line.
    # Should only be called after can_handle returns true
    
    # We can let Translate::arguments handle the majority of special
    # characters. The exception is $@, because it must append the array
   
    # For now, we'll assume it's going at the end of the string
    # Actually, the order of execution really shouldn't matter that much
    
    my $command = $_[0];
    my $num_argslists = 0;
    
    while ($command =~ /\"\$\@\"/) {
        $command =~ s/\"\$\@\"//;
        $num_argslists++;
    }
    
    my $result = 'subprocess.call(['.Translate::arguments($command, "str").'])';
    
    while ($num_argslists != 0) {
        $result =~ s/\)$/\+sys\.argv\[1\:\]\)/;
        $num_argslists--;
    }
    
    return $result;
}

1;
