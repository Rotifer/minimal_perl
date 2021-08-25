#!/usr/bin/perl

use strict;
use warnings;

# A more verbose version of ex001_column_name_count.pl
my $file = $ARGV[0];
my $first_line = <ARGV>;
my @column_names = split(/\t/, $first_line);
my @column_names_indexed = ();
for(my $i = 0; $i <= $#column_names; $i++) {
    my $column_name = $column_names[$i];
    my $column_name_indexed = ($i + 1) . ' ' . $column_name;
    push(@column_names_indexed, $column_name_indexed);
}
my $output = join("\n", @column_names_indexed);
print $output;


