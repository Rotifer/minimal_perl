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


