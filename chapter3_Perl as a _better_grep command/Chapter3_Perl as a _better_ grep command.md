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


