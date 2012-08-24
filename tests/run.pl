#!/usr/bin/perl 
# Find all test files
$raw_files = `find . -name "*.sh"`;
@tests = split (/\s/, $raw_files);
for $test (@tests) {
    print $test."\n";
}
