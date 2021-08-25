# Mimimal Perl

## Introduction

These are my notes on the excellent book, _Minimal Perl_ by Tim Maher, Manning 2006. Although this book is old, it remains relevant
and useful. I think it showcases Perl's strengths as a UNIX scripting language that can complement, extend and replace tools such as shell
Awk, sed and grep. The author was an established Unix trainer and his expertise in this field shines through in the book so it acts as a
a good UNIX refresher too.

Since the book is quite old, some of its Perl is quite dated. That said, don't let its age put you off; it is still 
an excellent book and reading it will make you both a better UNIX programmer and a better Perl programmer. The examples here will use modern Perl 5

Douglas Crockford wrote the famous book "JavaScript - The Good Parts" that showed how another quirky language -JavaScript- could be used effectively by 
avoiding problematic features and using a core set of "good features". The _Minimal Perl_ book takes a similar approach by using just a subset of the Perl.
And, yes, much as I rate it, I think Perl is a "quirky" language

I work in bioinfomratics and have used Perl on and off for over 20 years; I wrote my first Perl scripts when it was extremely popular and a go-to language
writing web applications. However, in the intervening years, I have seen it deposed as the language of choice in bioinformatics by both R and Python. This has been
mirrored by a general decline in its use so much so that now many young programmers will not have even heard of it. Despite all that, I have continued to use it
for certain tasks where I think it is a good fit. I reserve it for small applications that are a stretch for bash. Perl one-liners might be all I need or I may mix it with bash or use it to wrap some UNIX tool or other. I avoid object oriented Perl because I think it isn't worth the effort and if I need that sort of an application, I use Python instead because that has become the default developement language where I work. For reusable Perl code, I write modules that contain subroutines; that works for me and with proper documentation and testing, I think it can take you a long way. I know there are some OO extensions for Perl such as _Moose_ that are 
supposed to be very good but I haven't used them so cannot give a valid opinion either way. The corinna project might bring native OO to Perl in the future. Regarding Perl 6/Rakuu, I haven't used it and won't comment further on it here. I am using Perl version 5.34 but any version >5.14 should be fine for all the code examples.

Personal opinion: I think OO is over-used and sometimes abused.



## Example data


for the early chapters of the book, I havve used the protein-coding human gene set of around 19k rows from the HUGO Human Gene Nomenclature
(HGNC) data set available [here](http://ftp.ebi.ac.uk/pub/databases/genenames/hgnc/tsv/locus_types/gene_with_protein_product.txt). I have chosen it because:

- It is a file that I am familiar with
- It has lots of columns and some of the columns are multi-values
- It is typical of the types of files that I  deal with on a daily basis

Any readers who have little or no biology background need not be concerned and can just trat it as a tab-delimited set of records

If applicable, I will provide the code to perform typical tasks using both Unix tools and Perl. If a task is impossible or unfeasible with either approach,
I will flag it as such

### Downloading the data

If _curl_ is insalled you can use that as shown below.

```{console}
curl  http://ftp.ebi.ac.uk/pub/databases/genenames/hgnc/tsv/locus_types/gene_with_protein_product.txt -o gene_with_protein_product.txt -s
```

Alternatively, you can use the Perl _LWP::Simple_ package which comes with the standard Perl distribution. Note how I have used the _File::Basename_
package to extract the target file name using its exported _basename_ function which is analagous to the its UNIX namesake.

```{perl}
#!/usr/bin/perl

use strict;
use warnings;

use File::Basename;
use LWP::Simple;

my $url = 'http://ftp.ebi.ac.uk/pub/databases/genenames/hgnc/tsv/locus_types/gene_with_protein_product.txt';
my $file = basename($url);

getstore($url, $file);
```

A third approach to downloading the file is embedding where we could embed the _curl_ command in a Perl script or embed the Perl command in a shell script.
Perl was originally conceived as a __glue__ language so it unsurprisingly excels at managing UNIX utilities. This is a theme we will explore in much greater
depth as we proceed.

### Exploring the data

When working with this types of text file, the first two questions I ask of it are: how many columns and how many rows does it have?

#### Row count
 
In shell, we can do the following:

```{console}
wc -l gene_with_protein_product.txt
# =>19194
```

This does the same thing in Perl executed from the shell command line as a one-liner

```
perl -pe '}{$_=$.' gene_with_protein_product.txt
```

This works but I admit I don't understand how it works, I took it from [PerlMonks](https://www.perlmonks.org/?node_id=538824)

Clearly, _wc -l_ is the best option here.

#### Column count and column names

```{console}
head -1 gene_with_protein_product.txt | cat -vet
```

This short and useful command sequence reads as follows: take the first line of the file and pipe it to _cat_ using the _-e_ option
so that non-printing characters (with the exception of tabs, new-lines and form-feeds) are printed visibly. The tabs are now visible
as __^I__.

It is useful to have the column names extracted and numbered so that we can see how many there are, their order and the total number.
Another piped sequence of UNIX command can do this easily:

```{console}
head -1 gene_with_protein_product.txt | tr '\t' '\n' | cat -n # 53 columns!
```

The command sequence above reads as follows:

- get the first line  (_head -1_) and pipe it to _tr_
- _tr_ converts the tabs into new lines to transpose the line (columns => rows)
- _cat -n_ prints the transposed line with line numbers prepended


Here is the output:

```
     1	hgnc_id
     2	symbol
     3	name
     4	locus_group
     5	locus_type
     6	status
     7	location
     8	location_sortable
     9	alias_symbol
    10	alias_name
    11	prev_symbol
    12	prev_name
    13	gene_family
    14	gene_family_id
    15	date_approved_reserved
    16	date_symbol_changed
    17	date_name_changed
    18	date_modified
    19	entrez_id
    20	ensembl_gene_id
    21	vega_id
    22	ucsc_id
    23	ena
    24	refseq_accession
    25	ccds_id
    26	uniprot_ids
    27	pubmed_id
    28	mgd_id
    29	rgd_id
    30	lsdb
    31	cosmic
    32	omim_id
    33	mirbase
    34	homeodb
    35	snornabase
    36	bioparadigms_slc
    37	orphanet
    38	pseudogene.org
    39	horde_id
    40	merops
    41	imgt
    42	iuphar
    43	kznf_gene_catalog
    44	mamit-trnadb
    45	cd
    46	lncrnadb
    47	enzyme_id
    48	intermediate_filament_db
    49	rna_central_ids
    50	lncipedia
    51	gtrnadb
    52	agr
    53	mane_select
```


There are __53__ columns at the time this file was downloaded! That gives us 19194 * 53 "cells"
We can use a Perl one-liner as follows to do the calculation


```{console}
perl -e 'print 53 * 19194, "\n";' # 1017282
```

I always use Perl for these types of calculations because I can never remember the shell syntax

Here is one way to generated the same output for the column names as done above with a UNIX pipe


__ex001_column_name_count.pl__

```{perl}
#!/usr/bin/perl

use strict;
use warnings;


my $i = 0;
print join("\n", map( {++$i . " $_" } split(/\t/, <>)));
```

Invoke with:

```{console}
perl ex001_column_name_count.pl gene_with_protein_product.txt
```

There is a lot going on in this short script with use of multiple defaults for __special variables__. Let's break it down:

- Script arguments are assigned to the special variable __@ARGV__
- Another special variable, __ARGV__, is the file handle that iterates over __@ARGV__
- __ARGV__ is the default when no the input operator, __<>__ is empty 
- If the input operator __<>__ is called in a loop, it will iterate over all the lines
- In this example, it is called just once inside the __split__ function so it returns the first line only
- The __split__ function returns a list of column names
- The column name list elements are then processed in an implicit loop by the __map__ function
- __map__ assigns each element to the special variable <em>$_</em> and prepends an incrementing integer
- __map__'s output list is then passed to the __join__ function
- The __join__ function returns a string with thee list's elements concatenated with new line characters
- This is then printed to the console


A more verbose version of the script above might help to clarify the steps involved.

__ex002_column_name_count.pl__

```{perl}
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
```

This is a much more verbose version of the earlier script with each step spelled out in what some call "baby Perl".
When starting out with Perl, it is often advisable to write scripts in this explicit step-by-step fashion until you gain confidence with the language.
We are now using __@ARGV__ and the the special file handle, __ARGV__, explicitly while the default input variable <em>$_</em> has been eliminated
See also how the __map__ call has been replaced by the simple C-style __for__ loop! Experienced Perl programmers would not write scripts this way but this
version has the virtue of being easy to explain, especially to those with limited Perl exposure.


