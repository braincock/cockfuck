# The cockfuck Language #

cockfuck is a variation on the famous esoteric programming language
[brainfuck](http://esolangs.org/wiki/brainfuck), a Turing tarpit
consisting of eight (rather nondescript) symbols. cockfuck, by contrast,
is a Turing cumbucket that uses nine basic symbols to form an infinite
semantic space of ASCII cocks --- some intact, some severed, some
sounded, some effusively pleasured.

The cockfuck distribution consists of this language specification and
three Perl scripts:

1. `cockfuck.pl`: The cockfuck interpreter. 
2. `brain2cock.pl`: The brainfuck-to-cockfuck translator.
3. `cock2brain.pl`: The cockfuck-to-brainfuck translator.

The interpreter reads cockfuck source from a file and executes it,
taking input either from stdin or as specified by redirection. The
translators read brainfuck or cockfuck source from a file, as
appropriate, and print the translation to stdout; all tests to date
indicate that the interconversion is (ahem) idempotent.

## A Summary of cockfuck Syntax ##

Five of cockfuck's basic symbols (`>`, `D`, `=`, `8`, and `B`) are used
for manipulating data; two (`~` and `-`) are used for I/O; and two
(`` 8=,` `` and `` `,=> ``) manage control flow. All other symbols are
ignored; indeed, the cockfuck interpreter strips them from source.

### cockfuck Syntax, Part I: Working the Shafts ###

As in brainfuck, cockfuck reads to and writes from an array of bytes. In
cockfuck, this array has 65536 elements. The symbols used to form
commands for moving the data pointer or modifying the data are glans
(`>` or `D`), shafts (`=`), and balls (`8` or `B`).

#### `>` ####

**Tapered glans.** Increment the data pointer or the corresponding byte.

#### `D` ####

**Broad glans.** Decrement the data pointer or the corresponding byte.

#### `=` ####

**Shaft.** The length of a cock --- the number of shafts connecting the
glans and balls --- indicates the number of times to increment or
decrement the target of the operation.

#### `8` ####

**Hanging balls** dictate that we operate on the data pointer.

#### `B` ####

**Cupped balls** Dictate that we operate on a byte.

Given these definitions, it is trivial to show that cockfuck sports
four basic (intact, unit) cocks:

1. brainfuck `>` is equivalent to cockfuck `8=>`
2. brainfuck `<` is equivalent to cockfuck `8=D`
3. brainfuck `+` is equivalent to cockfuck `B=>`
4. brainfuck `-` is equivalent to cockfuck `B=D`

In brainfuck, repeated operations of the same type are written as
strings of identical symbols. For example, `+++` increments the byte
under the data pointer three times. While repeated unit cocks can
certainly be used for this purpose, style and physiology dictate
instead that a single cock engorge to the length necessary to effect
the desired result. That is to say, brainfuck `+++` should be written
in cockfuck as `B===>`.

Lecherous readers may wonder why the decrement is represented by a
broad glans rather than the more obvious reversed-taper (`<`), which
would lead to a pair of left-facing unit cocks, `<=8` and `<=B`, that 
are dual to `8=>` and `B=>`. One attraction of this alternate command
structure is that it would allow for depictions of 
[docking](http://www.urbandictionary.com/define.php?term=docking). 
Even so, aesthetic considerations regarding the placement of I/O symbols
relative to glans dictated that cockfuck be worn to the right.



### cockfuck Syntax, Part II: Not a One-Way Skeet ###

cockfuck's I/O symbols are jizz (`~`) and
[sounds](http://en.wikipedia.org/wiki/Urethral_sounding) (`-`):

#### `~` ####

**Jizz.** Output the byte under the data pointer, directly equivalent to the
`.` operation in brainfuck. The length of a rope of jizz indicates the
number of times the byte should be output.

#### `-` ####

**Sound.** Accept a byte of input and store it under the data pointer,
directly equivalent to the `,` operation in brainfuck. Sounds can be
extended to arbitrary length --- like their real-life equivalents ---
indicating that multiple bytes should be accepted, but only the last
byte will be saved. Once the input stream is exhausted, further sounding
returns 0.

As mentioned above, cocks always face to the right; this is to ensure
that arbitrary sequences of jizz and sounds are either issued from a
glans or exposed within a flow-directing chopticock. (The latter
condition has its own gruesome charm, which compensates somewhat for
the ban on docking.) It is certainly possible to write valid cockfuck
that flouts this intention --- one need only perform I/O operations at
the beginning of a program --- but in these cases the stylish
cockfucker will add a trivial `8=>` at the start of the source.



### cockfuck Syntax, Part III: Chop and Hop ###

A cockfuck program's instruction pointer moves from left to right,
reading cocks, jizz, and sounds as it goes. This basic flow can be
modified using the severed and bleeding members known as chopticocks
(`` 8=,` `` and `` `,=> `` being their constituent parts).

#### `` 8=,` `` ####

**Choptiballs.** If the byte under the data pointer is zero, move the
instruction pointer to the command after the matching choptiglans;
otherwise, move the instruction pointer to the next command. Directly
equivalent to brainfuck `[`.

#### `` `,=> `` ####

**Choptiglans.** If the byte under the data pointer is nonzero, move the
instruction pointer to the command after the matching choptiballs;
otherwise, move the instruction pointer to the next command. Directly
equivalent to brainfuck `]`.

The programmer may wish, for aesthetic reasons, to depict chopped shafts
of various lengths; this is allowed, though it has no impact on
functionality.

## Sample cockfuck programs ##

### cat ###

Per the Esolang page, cat has a very simple brainfuck implementation
when EOF returns 0:

    ,[.,]

The cockfuck source produced by `brain2cock.pl` is kinky, yet still
economical:

    -8=,`~-`,=>

Of course, we prefer the more stylish equivalent:

    8=>-8=,`~-`,=>



### Hello World! ###

Esolang lists two brainfuck implementations of "Hello World!" The
simpler one is:

    ++++++++[>++++[>++>+++>+++>+<<<<-]>+>+>->>+[<]<-]>>.>---
    .+++++++..+++.>>.<-.<.+++.------.--------.>>+.>++.

The cockfuck equivalent is bracingly lusty:

    B========>8=,`8=>B====>8=,`8=>B==>8=>B===>8=>B===>8=>B=>
    8====DB=D`,=>8=>B=>8=>B=>8=>B=D8==>B=>8=,`8=D`,=>8=DB=D
    `,=>8==>~8=>B===D~B=======>~~B===>~8==>~8=DB=D~8=D~B===>~
    B======D~B========D~8==>B=>~8=>B==>~

The more complicated brainfuck implementation provided by Esolang is:

    >++++++++[<+++++++++>-]<.>>+>+>++>[-]+<[>[->+<<++++>]<<]
    >.+++++++..+++.>>+++++++.<<<[[-]<[-]>]<+++++++++++++++.>>
    .+++.------.--------.>>+.>++++.

And its cockfuck counterpart is rather fearsome, by any standard:

    8=>B========>8=,`8=DB=========>8=>B=D`,=>8=D~8==>B=>8=>B=>8=>
    B==>8=>8=,`B=D`,=>B=>8=D8=,`8=>8=,`B=D8=>B=>8==DB====>8=>`,=>
    8==D`,=>8=>~B=======>~~B===>~8==>B=======>~8===D8=,`8=,`B=D`,=>
    8=D8=,`B=D`,=>8=>`,=>8=DB===============>~8==>~B===>~B======D~
    B========D~8==>B=>~8=>B====>~



### ROT13 Encoder ###

A brainfuck [ROT13 encoder](http://en.wikipedia.org/wiki/brainfuck):

    -,+[-[>>++++[>++++++++<-]<+<-[>+>+>-[>>>]<[[>+<-]>>+>]<<<<<-]]
    >>>[-]+>--[-[<->+++[-]]]<[++++++++++++<[>-[>+>>]>[+[<+>-]>+>>]
    <<<<<-]>>[<+>-]>[-[-<<[-]>>]<<[<<->>-]>>]<<[<<+>>-]]<[-]<.[-]<-,+

cockfuckingly:

    B=D-B=>8=,`B=D8=,`8==>B====>8=,`8=>B========>8=DB=D`,=>8=DB=>8=D
    B=D8=,`8=>B=>8=>B=>8=>B=D8=,`8===>`,=>8=D8=,`8=,`8=>B=>8=DB=D`,=>
    8==>B=>8=>`,=>8=====DB=D`,=>`,=>8===>8=,`B=D`,=>B=>8=>B==D8=,`B=D
    8=,`8=DB=D8=>B===>8=,`B=D`,=>`,=>`,=>8=D8=,`B============>8=D8=,`
    8=>B=D8=,`8=>B=>8==>`,=>8=>8=,`B=>8=,`8=DB=>8=>B=D`,=>8=>B=>8==>
    `,=>8=====DB=D`,=>8==>8=,`8=DB=>8=>B=D`,=>8=>8=,`B=D8=,`B=D8==D
    8=,`B=D`,=>8==>`,=>8==D8=,`8==DB=D8==>B=D`,=>8==>`,=>8==D8=,`8==D
    B=>8==>B=D`,=>`,=>8=D8=,`B=D`,=>8=D~8=,`B=D`,=>8=DB=D-B=>`,=>

A luscious litany of lingams, isn't it? (And so functional, too!)



## A Disclaimer and an Invitation ##

Lest we be accused of fostering patriarchy through oblivious
brogramming, we would like to encourage the creation of further
brainfuck variations using naughty ASCII. One obvious variation that
respects the preexisting \*fuck naming convention might be tittyfuck;
departing from \*fucking, one might use vulvas and penises as
functional symbols in a Turing cumbucket called YoniBaloney...

Wishing you many hours of enthusiastic esolangus,

The Authors, 7th June 2014

## License ##

                DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
                        Version 2, December 2004
    
     Copyright (C) 2004 Sam Hocevar <sam@hocevar.net>
    
     Everyone is permitted to copy and distribute verbatim or modified
     copies of this license document, and changing it is allowed as long
     as the name is changed.
    
                DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
       TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
    
      0. You just DO WHAT THE FUCK YOU WANT TO.

