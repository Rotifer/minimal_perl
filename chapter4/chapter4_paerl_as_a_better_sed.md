# Chapter 4: Perl as a better sed

__sed__ is a stream editor that applies a predetermined set of editing commands to the stream of data flowing through it.

Reverse two fields in a file

```{console}
cat farscpaers
sed 's/^\([^ ][^ ]*\) \([^ ][^ ]*\).*$/\2, \1/' farscapers 
awk '{ print $2 ", " $1 }' farscapers
```

sed is most commonly used in just two kinds of applications: 

1.simple text substitutions (that don’t involve fields!), and 
2. extractions of lines by number. 

__Task__: Strip preceding _/etc/ off path

```{console}
echo /etc/pwd | sed 's/\/etc\///g'
echo /etc/pwd | sed 's|\/etc\/||g'
echo /etc/pwd | perl -wpl -e  's|\/etc\/||g'
```

sed, like Perl, supports _arbitrary delimiters_

Perl provides automatic _directory file skipping_ to ensure that (nonsensical) requests for directory files 
to be edited aren’t honored. 

```{date}
DATE=`date`                       
echo $DATE 
Tue  7 Sep 2021 19:36:53 BST
echo $DATE | sed 's/Tue/Tuesday/g'
echo $DATE | perl -wpl -e 's/Tue/Tuesday/g;'
```

__Task__: Squeeze multiple spaces into a single space and surround each word in single quotes

```{console}
echo "Perl   is      a useless language" | perl -wpl -e 's/\b\w+\b/\047$&\047/g; s/\s+/ /g;'
```

The sed command can restrict its attentions to particular lines, specified either by a single line number or 
by a range of two (inclusive) line numbers separated by a comma, placed before the s. 

__Task__: Change just the first line of a file

```{console}
sed '1s/Sun/Sunday/g' beatles
```

Although Perl doesn’t support the 10,19s/old/new/g syntax of sed, it does keep track of the number of the current 
record (a line by default) in the special variable __“$.”__

if the n or p invocation option is used. This being the case, processing specific lines is accomplished by composing 
an expression that’s true when the line number is in the desired range, and then using the logical and to make the 
operation of interest conditional on that result.

```{console}
perl -wpl -e '$. == 1 and s/Sun/SUNDAY/g;' beatles
```

Edit lines 3-10

```{console}
perl -wpl -e '3 <= $. and $. <= 11  and s/old/new/g;' file
```

Unlike sed, Perl lets you perform substitutions on arbitrarily defined records. 

See data in file _data_east_


```{console}
perl -00 -wpl -e '$.  == 2 and s/\bSun\b/Sunday/g;  $.  == 2 and s/\bMon\b/Monday/g;' data_east
```

The use of -00 enables paragraph mode and the equality tests (==) on the values of the “$.”
 variable select the record of interest. Note that the occurrences of Sun and Mon in paragraph 2 were modified as desired, 
while those in paragraph 3 were correctly exempted from editing.

Like grep sed recognizes parentheses as literal characters unless they’re backslashed, which turns them into 
parentheses that capture what’s matched by the regex between them. 
In contrast, Perl’s parentheses are of the capturing type unless they’re backslashed, which converts them to literal characters.

The second most common use of sed in contemporary computing is to extract and print an arbitrary range of lines from a file 


For example, here’s how to skip over the heading line from the beatles file (“Beatles playlist”) and print 
the song titles only, using sed


```{console}
sed -n '2,$p' beatles
```

In Perl:

Printing lines by number is accomplished in the same general way as the line-specific editing discussed earlier. 
The only differences are that automatic-printing is disabled (i.e., the n option is used rather than p) and a print
 function is made conditional on the test of the line number, rather than a substitution operator.

```{console}
perl -wnl -e '$. >= 2 and print;' beatles
```

Printing in paragraph mode

```{console}
perl -00   -wnl -e '3 <= $. and $. <= 11 and print;' f1 f2
```

A character set is a particular mapping of numbers to characters

__Task__: Replace leading tabs with 4 spaces

```{console}
perl -wpl -e 's/^\t/\040\040\040\040/g;' file
```

In-place file editing so that the original is preserved as a back-up

```{console}
perl -i.bak -wpl -e 's/\bPANTS\b/TROUSERS/ig;' pantaloony
```

Why did the changes appear in the file, rather than only on the screen? Because the i invocation option, 
which enables in-place editing, causes each input file (in this case, pantaloony) to become the destination for 
its own filtered output. That means it’s critical when you use the n option not to forget to print, or else the input file 
will end up empty! So I recommend the __use of the p option in this kind of program__, 
to make absolutely sure the vital print gets executed automatically for each record.

But what’s that .bak after the i option all about? That’s the (arbitrary) filename extension that will be applied to the backup copy of each input file. Believe me, that safeguard comes in handy when you accidentally use the n option (rather than p) and forget to print.

Now that you have a test case that works, all it takes is a slight alteration to the original command to
 handle lots of files rather than a single one:

```{console}
perl -i.bak -wpl -e 's/\bPANTS\b/TROUSERS/ig;' *
```

__Editing with scripts__

It’s tedious to remember and retype commands frequently—even if they’re oneliners—so soon you’ll see a 
scriptified version of a generic file-changing program.

See _change_file__

The s option on the shebang line requests the automatic switch processing that handles the command-line 
specifications of the old and new strings and loads the associated $old and $new variables with their contents. 
The omission of the our declarations for those variables (as detailed in table 2.5) marks both switches as mandatory.

See script _change_author_ for an example of using _BEGIN_ block

The regex looks for the shebang sequence (#!) at the beginning of the line, followed by the longest sequence of anything (.star; see table 3.10) leading up to /bin/. Willy wrote it that way because on most systems, whitespace is optional after the “!” character, and all command interpreters reside in a bin directory. This regex will match a variety of paths—including the commonplace /bin/, /local/bin/, and /usr/local/bin/—as desired.


Apart from performing the substitution properly, it’s also important that all the lines of the original file are sent out to the new version, whether modified or not. Willy handles this chore by using the p option to automate that process. He also uses the -i.bak option cluster to ensure that the original version is saved in a file having a .bak extension, as a precautionary measure.

insert_contact_info2: Addition of regex comments using the \x modifier:

```{perl}
# Rewrite shebang line to append contact info
$. == 1 and
# The expanded version of this substitution operator follows below:
#      s|^#!.*/bin/.+$|$&\n# Author: $author|g;
 s|
   ^         # start match at beginning of line
     \#!       # shebang characters
     .*        # optionally followed by anything; including nothing
     /bin/     # followed by a component of the interpreter path
     .+        # followed by the rest of the interpreter path
   $         # up to the end of line
  |$&\n\# Author: $author|gx; # replace by match, \n, author stuff
```

Clobber-proofing backup files in commands: __$SECONDS__

For commands typed interactively to a Shell, I recommend using -i.$SECONDS instead of -i.bak to enable 
in-place editing. This arranges for the age in seconds of your current Korn or Bash shell, which is
 constantly ticking higher, to become the extension on the backup file.

```{console}
echo $SECONDS
perl -i.$SECONDS -wpl -e 's/RE/something/g;'  file
```

Clobber-proofing backup files in scripts: __$$__
