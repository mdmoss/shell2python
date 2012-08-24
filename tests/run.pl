#!/usr/bin/perl 
# Find all test files
chdir ('..');
$raw_files = `find . -name "*.sh"`;
print $raw_files;
