# Chapter 5 - Perl as a better AWK

it’s a good idea to honor AWK by continuing to use its Pattern/Action model of programming—in Perl!

AWK is appreciated most widely for its field-processing capabilities

Perl’s capability of record separator matching allows you to match a newline (or a custom record separator), 
which is not allowed by any of the regex-oriented Unix utilities (grep, sed, awk, vi, etc.).

Almost all AWK special variables are named by sequences of uppercase letters, whereas most Perl variables have $-prefixed symbols 
for names.

- AWK’s $0 holds the contents of the current input record. In Perl, $0 holds the script’s name, and $_ holds the current input record.
- $1 and $F[0] variables hold the first field[b] of the current input record; $2 and $F[1] would hold the second field, and so forth.
- NR and $. The “record number” variable holds the ordinal number of the most recent input record.[c] After reading a two-line file followed by a three-line file, its value is 5.
- RS and $/ The “input record separator” variable defines what constitutes the end of an input record. In AWK, it’s a linefeed by default, whereas in Perl, it’s an OS-appropriate default. Note that AWK allows this variable to be set to a regex, whereas in Perl it can only be set to a literal string
- ORS and $\ Output record seprators
OFS and $, Output Field Separator
- NF and @F The “number of fields” variable indicates the number of fields in the current record. Perl’s @F variable is used to access the same information 
- ARGV and @ARGV The “argument vector” variable holds the script’s arguments.
- FILENAME and $ARGV These variables contain the name of the file that has most recently provided input to the program

$&, $' and $` regex match capture variables have no equivalents in AWK

For example, here are AWK and Perl programs that display the contents of file with prepended line numbers, using equivalent special variables:

```{console}
awk        '{ print NR  ": "  $0 }'  file
perl –wnl -e 'print $., ": ", $_; '  file
```

__Perl’s variable interpolation__

Like the Shell, but unlike AWK, Perl allows variables to be interpolated within double-quoted strings, which means the variable names are replaced by their contents.

Perl provides in-place editing of input files, through the –i.ext option. 
This makes it easy for the programmer to save the results of editing operations back in the original file(s). AWK lacks this capability.

Another potential advantage is that in Perl, automatic field processing is disabled by default, so JAPHs only pay its performance 
penalty in the programs that benefit from it. 
In contrast, all AWK programs split input records into fields and assign them to variables, whether fields are used in the program or not

## Example data

Created from the Hugo genes file using AWK to select some columns

```{console}
awk -F'\t' 'BEGIN{OFS="\t"} {print $1, $2, $3, $8, $9}' ../gene_with_protein_product.txt >awk_perl_example_file.tsv
wc -l awk_perl_example_file.tsv # 19194 lines
```

In AWK, $1 means the first field of the current record, $2 the second field, and so forth. By default, any sequence of one 
or more spaces or tabs is taken as a single field separator, and each line constitutes one record. 

Perl'smechanism for accessing fields involves copying the fields of the current record from the field container @F into a parenthesized 
list of user-defined variables.

nvolves copying the fields of the current record from the field container @F into a parenthesized list of user-defined variables.

### Perl version of the AWK script above

```{console}
perl  -F"\t" -anE '@fields = @F[0, 1, 2, 7, 8]; say join("\t", @fields);' ../gene_with_protein_product.txt >awk_perl_example_file.tsv
```

__A few notes on the Perl version__

- The **-E** option in place of -e allows us to use __say__ in place of print thereby avoidng the need to add new lines to output
- Perl list slicing is very convenient for extracting fields from @F

### Counting the number of columns

Given a delimiter, we would like to check that each row has the same number of columns.

```{console}
# AWK
awk -F'\t' ' {print NF}' ../gene_with_protein_product.txt | uniq
# Perl
perl  -F"\t" -anE 'BEGIN{$NF = 0;} $NF = @F; say $NF;' ../gene_with_protein_product.txt | uniq
```






