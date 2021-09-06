# Chapter 3. Perl as a (better) grep command

 the basic function of grep continues to be the identification and extraction of lines that match a pattern.

Many newer versions of grep (and some versions of its enhanced cousin egrep) have been upgraded to support the \< \> word-boundary metacharacters

The word-boundary metacharacter lets you stipulate where the edge of a word must occur, relative to the material to be matched. It’s commonly used to avoid substring matches, as illustrated earlier in the example featuring the \b metacharacter.

Backreferences, provided in both egrep and Perl, provide a way of referring back to material matched previously in the same regex using a combination of capturing parentheses 

he fgrep utility automatically treats all characters as literal, whereas grep and egrep require the individual backslashing of each such metacharacter, which makes regexes harder to read. Perl provides the best of both worlds: You can intermix metacharacters with their literalized variations through selective use of \Q and \E to indicate the start and end of each metacharacter quoting sequence

Arbitrary record definitions allow something other than a physical line to be defined as an input record. The benefit is that you can match in units of paragraphs, pages, or other units as needed. 

```{console'}
perl -wnl -e '/cd38/i and print;' ../gene_with_protein_product.txt
```

It says: “Until all lines have been processed, read a line at a time from file (courtesy of the n option), determine whether RE matches it, and print the line if so.”

RE is a placeholder for the regex of interest, and the slashes around it represent Perl’s matching operator. The w and l options, respectively, enable warning messages and automatic line-end processing, and the logical and expresses a conditional dependency of the print operation on a successful result from the matching operator.

Although this one-line Perl command performs the most essential duty of grep well enough, it doesn’t provide the services associated with any of grep’s options, such as ignoring case when matching (grep -i), showing filenames only rather than their matching lines (grep -l), or showing only non-matching lines (grep -v). 


__Single quote literal__ A good solution is to represent the single quote by its numeric value, using a string escape 


```{console}
perl -wnl -e '/D\047A/ and print;' priorities
```

\Q...\E
Quoting metacharacters
Causes the enclosed characters (represented by ...) to be treated as literal, to obtain fgrep-style matching for all or part of a regex.

$& variable that contains the contents of the last match

Perl’s approach—of delimiting the metacharacters to be literalized—is even better than fgrep’s, because it allows metacharacters that are within the regex but outside the \Q...\E sequence to function normally. 

__$&__: Sometimes you need to refer to what the last regex matched, so, like sed and awk, Perl provides easy access to that information. 


```{console}
perl -wnl -e '/\b\d\d\d\d\d\b/ and print $&;' members
```

The command uses “print $&;” to print only the match, rather than “print;”, which would print the entire line (as greppers do).

Another variation on matching is provided by grep’s __-v option__, which inverts its logic so that records that don’t match are displayed. In Perl, this effect is achieved through conditional printing—by replacing the and print you’ve already seen with or print—so that printing only occurs for the failed match attempts.

Find all lines in file with no Ensembl gene ID (ID begins with ENSG)

```{console}
perl -wnl -e '/ENSG/  or  print;' ../gene_with_protein_product.txt
```

In some cases, you don’t want to see the lines that match a regex; instead, you just want the names of the files that contain matches. With grep, you obtain this effect by using the l option, but with Perl, you do so by explicitly printing the name of the match’s file rather than the contents of its line.


using the special filename variable __$ARGV__

```{console}
perl -wnl -e '/\bCD38\b/i and print $ARGV and close ARGV;' ../*
```

```{console'
perl -wnl -e '/:[A-Z][A-Z]:\d\d\d\d\d$/ or print;' addresses.dat
```

The grep command has an enhanced relative called egrep, which provides metacharacters for alternation, grouping, and repetition 

```{console}
grep '\<ESR\>.*\<SRV\>' projects
# egrep
egrep '\<ESR\>.*\<SRV\>|\<SRV\>.*\<ESR\>' projects
# Cascading filter
egrep '\<ESR\>' projects | egrep '\<SRV\>'
```

What’s the alternative? To use Perl’s logical and to chain together the individual matching operators, which only requires a single perl process and zero pipes, no matter how many individual matches there are:

```{console}
perl -wnl -e '/\bESR\b/ and
                       /\bSRV\b/ and
                            /\bCYA\b/ and
                                 /\bFYI\b/ and
                                      print;' projects
```

Note that you can’t make any comparable modification to the stack of egrep commands shown earlier, because egrep’s specialization for matching prevents it from supporting more general programming techniques, such as this chaining one.

There’s much to recommend this Perl solution over its more resource-intensive egrep alternative: It requires less typing, it’s portable to other OSs, and it can access all of Perl’s other benefits if needed later.

In grepping operations, showing context typically means displaying a few lines above and/or below each matching line, which is a service some greppers provide. Perl offers more flexibility, such as showing the entire (arbitrarily defined) record in which the match was found, which can range in size from a single word to an entire file.

__Paragraph mode__

Although there are many possible ways to define the context to be displayed along with a match, the simple option of enabling paragraph mode often yields satisfactory results, and it’s easy to implement. All you do is include the special -00 option with perl’s invocation  which causes Perl to accumulate lines until it encounters one or more blank lines, and to treat each such accumulated “paragraph” as a single record.

__File mode__

In the following command, which uses the special option -0777  each record consists of an entire file’s worth of input:

```{console}
perl -0777 -wnl -e '/RE/ and print;' file file2 
```

Unlike its UNIX forebears, Perl’s regex facility allows for matches that span lines, which means the match can start on one line and end on another. 
To use this feature, you need to know how to use the matching operator’s __s__ modifier 

```{console}
lwp-request5: LWP-REQUEST5 is not an allowed method
```

lwp-request is new to me

Simple command-line HTTP client. Built with libwww-perl.

Make a simple GET request:
lwp-request -m GET http://example.com/some/path


matching operators can be chained together with the logical and to print records that match each of several regexes, using a technique called cascading filters. With a slight twist, chains of matching operators can be used to ensure that certain regexes are matched while others are not matched. You do this by preceding the matching operators that are required to fail with the negation operator, “!”.

Check out script __greperl__

```{console}
./greperl -pattern=immune ../gene_with_protein_product.txt
```
The module called __String::Approx__ and downloaded and installed it from CPAN. It provides an approximate match function called amatch, which accepts matches if the mismatch with the target string is within an allowed percentage.

__Summary__

- Word-boundary metacharacters (\<, \>)
- Compact character-class shortcuts (such as \d for a digit)
- Control character representations (such as \t for the tab character)
- Provisions for embedding commentary and arbitrary whitespace in regex fields
- Access to match components (e.g., as provided by Perl’s $& variable)
- The ability to define custom input records (such as Perl’s paragraph mode)
- The ability to match across lines (e.g., as provided for by Perl’s single-line mode)
- Automatic skipping of directory files that are inadvertently named as program arguments
- The ability to customize the format used for printing matches within records (as provided for by Perl’s ‘$,’ and ‘$"’ variables)
- The ability to do “fuzzy” matching


