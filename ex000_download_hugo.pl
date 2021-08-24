#!/usr/bin/perl

use strict;
use warnings;

use File::Basename;
use LWP::Simple;

my $url = 'http://ftp.ebi.ac.uk/pub/databases/genenames/hgnc/tsv/locus_types/gene_with_protein_product.txt';
my $file = basename($url);

getstore($url, $file);
