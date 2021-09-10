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

We can eliminate the call to _uniq_

```{console}
# Perl
perl  -F"\t" -anE 'BEGIN {%rowcounts = ();} $NF = @F; $rowcounts{$NF} = ""; END {say join(", ", keys %rowcounts);}' ../gene_with_protein_product.txt
# AWK
awk -F'\t' ' {rowcounts[NF] = ""} END {for (nr in  rowcounts) { print nr} }' ../gene_with_protein_product.txt
```

These examples depend on the use of Perl’s n and a invocation options to load the fields of the current input record into @F.

An earlier example used slicing of the @F array to extract fields. The same effect can be achieved using __undef__ for unwanted columns like so:

```{perl}
(undef, $second, $third)=@F;
```

The first column and all columns to the right of the third column, if there are any,  will be excluded.

Our first task is to choose an appropriate Primary Option Cluster from table 2.9, which prescribes -wnla for field-processing
 applications where the default whitespace delimiters are desired. Perl’s n option requests the inclusion of an implicit input-reading loop, 
as we’ve discussed, and the a option additionally requests the automatic splitting of each input record into fields, which are stored in the @F array.


Example file from book called X

```{console}
cat X
awk '{ print $3 "\t" $1 }' X
perl -wnla -e '($b_date, undef, $fname)=@F; print "$fname\t$b_date";' X
# Same as above but dropped the -l option and replaced -e with -E so we can use thsay instead of print
perl -wna -E '($b_date, undef, $fname)=@F; say "$fname\t$b_date";' 
```

A fundamental difference is that Perl, like many other computer languages, requires commas to appear between arguments. 
In contrast, AWK allows commas to be present in print statements—to indicate that arguments should be separated in the output by the value of the 
OFS variable (see table 5.2)—or commas to be absent, to indicate that the arguments should be concatenated together on output.

By default, Perl’s a option splits input records into fields using whitespace characters as field separators. 

To change Perl’s idea of what constitutes a field separator, you specify with the F invocation option the desired character(s) or regular expression—as in AWK. 

```{console}
echo 'Stimey:Matthew Beard' | perl -wnlaF':' -e '($character)=@F; print $character;'
```

rgument to -F can use single or double quotes and can be a single character, e.g. tab ('\t') or a regex pattern such as '[\t:-]'; it is very flexible.

single quotes around their contents, to allow them to work properly when submitted to a Shell

After field processing, AWK’s next most highly prized feature is its ability to combine pattern matching with conditional execution. 

AWK’s creators recognized this fact and engineered it so that any of its activities could be dependent on the result of a match. Perl shares this property.

```{console}
perl -wnl -e '/CD\d{2,}/  and  print $_;' ../gene_with_protein_product.txt | perl -wanE 'say $F[1];'
```

Patterns in AWK and Perl needn’t be matching oriented; you can use any True/False expression as a conditional element, such as “$. > 42”

## Comparing Pattern/Action operation in AWK and Perl

- Print records 1 through 3 of the input.

```{console}
awk '1 <= NR && NR <= 3 {print}' ../gene_with_protein_product.txt
perl -wnle '1 <= $. and $. <= 3 and print' ../gene_with_protein_product.txt
```

- Print lines where the column number != 2

```{console}
# Dummy data
cat >columns
a:b:c 
d:e
f:g
h
:i:j            
k:l
^C
```

```{console}
awk -F: 'NR != 2 {print}' columns
perl -wanF: -e '@F != 2 and print' columns
```

- Prints records that have “9” at the beginning of the second field.

```{console}
# Create a dummy numbers file
cat >numbers.csv
10	12	13
11	91	12
34	18	12
56	9	21
0	0	0
23	12	-12
```

```{console}
awk -F"\t" '$2 ~ /^9/ {print}' numbers.csv
perl -wanF"\t" -e '$F[1] =~ /^9/ and print' numbers.csv
perl -wanF"\t" -E '$F[1] =~ /^9/ and say $F[0]' numbers.csv
```

- Prepend record numbers to records and prints them

```{console}
awk -F\t '{print NR "\t" $0}' numbers.csv
perl -wanF"\t" -e 'print "$.\t$_"' numbers.csv
```

- Print the last field of each line, using negative indexing in Perl’s case 

```{console}
awk -F"\t" '{print $NF}' numbers.csv
perl -wanF"\t" -e 'print $F[-1]' numbers.csv
```

- Report the total number of records read.

```{console}
awk  'END {print NR}' numbers.csv
perl -wn -E 'END {say $.}' numbers.csv
```

- For input lines consisting of individual numbers, reports the average of those numbers.

```{console}
# Extracting the first column for the average calculation
awk -F"\t" '{print $1}' numbers.csv | awk 'BEGIN { print "AVERAGE:"} { total=total + $0 } END {print total / NR}' 
perl -wanF"\t" -E  'say $F[0]' numbers.csv | perl -wnF"\t" -E 'BEGIN {say "AVERAGE:"} $total += $_; END {say $total/$.}'
```

The AWK programs in the upper panel of table 5.8 are of the Pattern-only type, employing the default Action of printing the selected records. Their Perl counterparts need an explicit and print clause to obtain the same functionality. Notice also that AWK’s && (logical and) used in the compound test of the first example becomes and in the Perl version. The examples of the first two rows demonstrate that Patterns don’t necessarily involve matching—conditions based on relational operators (“<=”, “!=”, etc.; see table 5.11) are among the others you can use.

The programs in the table’s middle panel are of the Action-only type, in which all records are selected for processing by the Action (with the help of the n option in the Perl versions).

The programs in the bottom panel each use at least one Pattern/Action pair, although that may not be readily apparent. That’s because BEGIN and END are pseudo-Patterns that respectively become True before any input has been read or after all input has been read. Accordingly, the statements in a BEGIN block are the first to be executed in a program, and those in the END block are the last.[17]

As shown in table 5.8’s last row, a BEGIN block is used for preliminary operations, such as printing a heading to describe the upcoming output of those programs. The programs then employ an Action-only statement to accumulate a total, and after all the input has been processed, they calculate and print the average of the numbers in and END block.


## Combining pattern matching with field processing

