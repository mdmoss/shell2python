#!/usr/bin/perl -w

# Matthew Moss
# mdm@cse.unsw.edu.au
# cs2041, 12s1

use strict;

use Assignment;
use Flow;
use Builtins;
use Command;

my %imports;
my $indent = 0;
my @python_chunks;

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
    $line =~ s/$comment//; 
    $line =~ s/^\s*//;
    $line =~ s/\s*$//;

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
    }
   
    my $line_imports = Translate::introspect_imports($python);

    $indent += Flow::get_indent_delta($line);
    $python = $python." ".$comment;
    $python =~ s/\s*$//;

    if ($python =~ /^else:/) {
        # This is a shameful workaround, but should do the job.
        push (@python_chunks, " "x($indent-4).$python."\n");
    } elsif ($python) {
        push (@python_chunks, " "x$indent.$python."\n");
    }

    if ($line_imports ne "") {
        @imports {keys %{$line_imports}} = values %{$line_imports};
    }
}

# Begin outputting the final result

# We're targeting python 2.7, so it makes sense to always use it
print "#!/usr/bin/python2.7\n";

foreach my $import (sort (keys %imports)) {
    print "import $import\n";
}

foreach my $line (@python_chunks) {
    {print $line};
}
