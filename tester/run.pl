#!/usr/bin/perl -w
use strict;
chdir ("..") or die "Couldn't change directory";
my $raw_tests = `find . -name "*.sh" `;
my @tests = split('.sh\s.', $raw_tests);
foreach my $test (@tests) {
    print $test;
    print " found\n";
}
