# Perl essentials



An invocation option is a character (usually a letter) that’s preceded by a hyphen and presented as one of the initial arguments to a perl command. 
Its purpose is to enable special features for the execution of a program.

- -e:
- -w:
- -n:
- -p:
- -l:
- -0 digits:


The purpose of Perl’s e invocation option is to identify the next argument as the program to be executed. 
This allows a simple program to be conveyed to perl as an interactively typed command rather than as a specially prepared file called a script.

A record is a collection of characters that’s read or written as a unit, and a file is a collection of records.

The particular character, or sequence of characters, that marks the end of the record being read is called the _input record separator_.

 great convenience to have the separators automatically stripped off as input is read, and then to have them automatically replaced when
 output is written by print. This effect is enabled by adding the l option to n or p with perl’s invocation.

when the __l__ option is used, a newline is automatically added at the end of print’s output: 

printf is immune to the effects of the l option.

__The $_ variable__

```{console}
echo "Groucho Harpo Chico" | tr ' ' '\n' > marx_bros
perl -wnl -e 'print;' marx_bros
# Same as
perl -wnl -e 'printf "$.: "; print;' marx_bros
```

The printf function is used to output the line-number prefix, to avoid shifting Groucho to the line below “1:”, which would happen if print with its automatic newline were used instead (as discussed earlier). Then “print;” writes out the current input line using its implicit $_ argument, on the same output line used by printf.

Can also write the last line above as:

```{console}
perl -wnl -e 'print "$.: $_";' marx_bros
```

## Loading modules: -M

A module is a collection of Perl code that’s packaged in a special format, which facilitates the reuse of its functions or subroutines in new programs. 

```{console}
perl -00 -wnl -e 'print "$.: $_";' memo
# -00: paragraph
```
To reformat the text by filling in short lines up to a 60-column boundary, you could filter the output with the standard Unix utility called fmt:

```{console}
perl -00 -wnl -e 'print "$.: $_";' memo | fmt -60
```

__NOTE__: __fmt__

Can use a Perl module as a more flexible alternative to _fmt_

```{console}
cpanm install Text::Autoformat
perl -M'Text::Autoformat-00'  -wn -e 'print autoformat "$.: $_", { right => 60 };' memo
```

[This module](https://metacpan.org/pod/Text::Autoformat) is not included with my Perl


the __s__ option for automatic processing of switch arguments (a.k.a. switches). 

```{console}
./show_files  -line_numbers memo
```

Notes on script show_files: 

- The conditionality of the printf statement on the value of the switch variable is expressed by the logical and operator (discussed in section 2.4.5), which has an “if/then” meaning here (like the Shell’s &&).

- Notice that the switch variable is named in an __our__ statement, which has the effect of making that switch optional.

- no our declarations should be made for the variables associated with required switches. 

As in the Shell, the __$0__ variable in Perl contains the name by which the script was invoked. It’s routinely used in warn and die messages.

hell programmers use the || and && symbols for logical or and logical and, respectively, yielding the following as a Shell equivalent of the previous command:

```{console}
[ -n "$quiet" ] ||    # test for non-emptiness
     echo "Processed record #$counter" >&2
```

Notice that the __>&2__ request is required to redirect output to STDERR in the Shell version, whereas Perl’s __warn__ does that automatically.

## BEGIN and END blocks

Like AWK, Perl provides a special way of indicating that certain statements should be executed before or after input processing occurs.

BEGIN blocks are typically used in such tasks as initializing scalar variables with numbers other than the default of zero, and printing headings for the program output that will follow. END blocks are customarily used to compute summary statistics after all input has been processed (such as averages), and to print final results.


```{console}
./double_space marx_bros 
# Compare to
./double_space -verbose marx_bros 
```

A BEGIN block is often the best place to determine whether a program has everything it needs to do its job, as you’ll see next.

Programs that use the n or p option to request an implicit input-reading loop need to handle these preliminary tasks in a BEGIN block. 


Some Perl special variables

__$"__: Characters that are automatically inserted between elements of arrays whose names appear in double quotes. 
__$,__: OFS in AWK


## Standard option clusters

it’s critical that certain options appear in the correct order relative to others. The e option, for instance, must come directly before the quoted program


Convert tabs in $_ to spaces before printing (expand is provided by __Text::Tabs__

## Using aliases for common types of Perl commands

The first alias is for Perl commands that only generate output:

```{console}
alias perl_o='  perl -wl  ' 
```

The doubled colons in Text::Autoformat tell Perl’s module-loading system to look for Autoformat.pm in the installation area under a directory called Text. 

 You can determine the pathname for perl by issuing the _type perl_ command to your Shell.
