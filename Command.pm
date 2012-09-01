#!/usr/bin/perl -w
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
    
    # We'll do this naively for now
    return 'subprocess.call(['.Translate::arguments($_[0]).'])';
}

sub get_imports {
    my %result;
    $result{'subprocess'} = 1;
    return \%result;
}

1;
