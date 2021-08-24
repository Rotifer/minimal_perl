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

```{console}
curl  http://ftp.ebi.ac.uk/pub/databases/genenames/hgnc/tsv/locus_types/gene_with_protein_product.txt -o gene_with_protein_product.txt -s
```



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



