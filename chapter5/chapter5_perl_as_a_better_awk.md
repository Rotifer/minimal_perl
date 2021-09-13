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

AWK’s Pattern/Action model allows you to combine a record selection step with the conditional printing of selective fields from a record, as in this simple example:

```{console}
awk '/^:/ {print}' columns # /pattern/ {action}
```

__mean_annual_precip__ script

```{perl}
#! /usr/bin/perl -00 -wnla
# Parses "Operational Climatic Data Summary" reports to extract
#  and print "mean annual precipitation" statistic for each file.
#
# Find precipitation record, and print its field #33 (index 32)
#
/^ 2\. PRECIPITATION /  and  print "\u$ARGV: $F[32]";
```

The script is designed to read multiple files in sequence (via option n) using paragraph mode (-00) and to automatically load the fields of each record into @F (using a). To home in on the correct portion of each city’s data file, the matching operator is used to find the paragraph with the PRECIPITATION heading by looking at the beginning of a paragraph for a space, a 2, a literal dot, and then two spaces before that word.

Next, the logical and is used to print the file’s name (via $ARGV; see table 2.7) followed by a colon, a space, and the value of the appropriate field within the record. Notice the use of \u before $ARGV (see table 4.5), which conveniently capitalizes the first letter of each city’s name. To help you visualize the implicit lines-to-record mapping that determines the index numbers for the fields in @F, consider the following data file:

A B
C D
When read in line mode, each line would have two fields, and the maximum index for each record’s @F would be 1.

However, if you read the same file in paragraph mode, each field would be considered part of the same record and treated for field-numbering purposes as if the input had looked like this:

A B C D
Therefore, field “D” would be stored under the index of 3, rather than under 1, as it would be with input records defined as lines.

__extract_cell1__

```{perl}
#! /usr/bin/perl -s -00 -wnla
# Prints field indicated by the $recnum/$fnum combination,
#   preceded by filename
# Example invocation: extract_cell1  -recnum=6 -fnum=33 miami new_york seattle

BEGIN {
    $fnum  and  $recnum or
        warn "Usage: $0 -recnum=M -fnum=N\n"  and
            exit 255;
    # Decrement field number, so user can say 1, and get index of 0
    $index=$fnum - 1;
}
$. == $recnum  and  print "\u$ARGV: $F[$index]";

# Reset record counter $. after end of each file
eof  and  close ARGV;
```

The script begins by checking that both of the obligatory switches have been supplied and by issuing a “Usage:” message and exiting if they weren’t. The last statement of the script senses whether input from the current file has been exhausted by calling the built-in eof function; if that’s true, the script closes the current file by referencing its filehandle, ARGV.[22] The effect is to reset the “$.” variable back to 1 for the next file, so the program can continue to correctly identify the record number desired by the value of “$.”.


__extract_cell2__

modifies the script to default to line-mode but to allow paragraph mode to be enabled by a command-line switch when desired. This requires removing the -00 invocation option from the shebang line and selectively enabling paragraph mode by conditionally assigning a null string to $/ 

```{console}
#! /usr/bin/perl -s -wnla

# Prints field indicated by $recnum/$fnum, preceded by filename.
# -fnum switch handles field numbers as well as negative indices.

# Invocation: extract_cell2 -p -recnum=6 -fnum=-1 miami new_york seattle

our ($p);       # -p switch for paragraph mode is optional

BEGIN {
  $fnum  and  $recnum or
      warn "Usage: $0 -recnum=M -fnum=N\n"  and
          exit 255;
  # Decrement positive fnum, so user can say 1, and get index of 0
  # But don't decrement negative values; they're indices already!
   $index=$fnum;               # initially assume $fnum is an index
   $index >= 1 and $index--;   # make it an index if it wasn't
   $p  and  $/="";             # set paragraph mode if requested
}
$. == $recnum  and  print "\u$ARGV: $F[$index]";

# Reset record counter $. after end of each file
eof  and  close ARGV;
```

Notice the use of the –p switch to enable paragraph mode, which isn’t hard-coded within the script as it was in the earlier version, and the use of the convenient -1 index rather than the field number of 101, to specify the last field of the record.

### Matching ranges of record

Notice that the apostrophe in “doesn’t” is represented by its numeric code, to avoid a clash with the surrounding Shell-level single quotes:

```{console}
perl -wnl -e '/File doesn\047t exist:/ and print;' error_log
```

A pattern range is a facility for selecting a series of records occurring between a pair of pattern matches. In a typical AWK usage, the programmer separates two slash-delimited regexes by a comma, and AWK’s default Action is used to print the matching lines along with those that fall between them.

```{console}
cat >days
Sunday
Monday
Tuesday
Wednesday
Thursday
Friday
Saturday
# CTRL-D

awk '/Monday/ , /Wednesday/' days
# The equivalent Perl program uses the range operator (..) between two matching operators:
perl -wnl -e '/Monday/ .. /Wednesday/ and print;' days
```


