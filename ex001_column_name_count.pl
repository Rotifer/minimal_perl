#!/usr/bin/perl

use strict;
use warnings;

my $i = 0;
print join("\n", map( {++$i . " $_" } split(/\t/, <>)));


