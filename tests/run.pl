#!/usr/bin/perl -w
use strict;
use File::Copy;

# Be really, really careful here
my $temp_location = "/tmp/shell2python/";

# Change to the directory where the script should be
chdir ("..");

# Find all test files
my $raw_files = `find . -name "*.sh"`;
my @tests = split (/\s/, $raw_files);

# Make a temp directory for running tests
`rm -rf $temp_location`;
mkdir ($temp_location) or die "Could not create temp file. Exiting.";

# Keep track of some statistics
my $tests_run = 0;
my $tests_passed = 0;

# Run the actual tests
for my $test (@tests) {
    my @test_path = split ('/', $test);
    copy ($test, $temp_location.$test_path[-1]);
    my $expected_output = `echo "123" | bash $temp_location$test_path[-1]`;
    my $python_test = $temp_location.$test_path[-1];
    $python_test =~ s/\.sh$/\.py/;
    `perl ./shell2python.pl $test > $python_test`;
    my $python_output = `echo "123" | python $python_test`;
    $tests_run++;
    if ($python_output eq $expected_output) {
        print "Test passed. $python_test performed correctly\n";
        $tests_passed++;
    } else {
        print "Test failed. $python_test did not perform as expected\n";
    }
}

print "\n$tests_passed/$tests_run tests passed\n";

