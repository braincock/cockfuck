#!/usr/bin/perl -w

#
#   DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE 
#            Version 2, December 2004 
#
# Copyright (C) 2004 Sam Hocevar <sam@hocevar.net> 
#
# Everyone is permitted to copy and distribute verbatim or modified 
# copies of this license document, and changing it is allowed as long 
# as the name is changed. 
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE 
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION 
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.
#
#
# brain2cock.pl - brainfuck to cockfuck translator
#

use strict;

my $program = join('',<>);

$program =~ s/[^><+\-.,\[\]]//gs;

while (length($program) > 0) {
    if      ($program =~ /^(>+)/) {
        print '8', '=' x length($1), '>';
        $program = substr($program,length($1));
    } elsif ($program =~ /^(<+)/) {
        print '8', '=' x length($1), 'D';
        $program = substr($program,length($1));
    } elsif ($program =~ /^(\++)/) {
        print 'B', '=' x length($1), '>';
        $program = substr($program,length($1));
    } elsif ($program =~ /^(-+)/) {
        print 'B', '=' x length($1), 'D';
        $program = substr($program,length($1));
    } elsif ($program =~ /^(\.+)/) {
        print '~' x length($1);
        $program = substr($program,length($1));
    } elsif ($program =~ /^(,+)/) {
        print '-' x length($1);
        $program = substr($program,length($1));
    } elsif ($program =~ /^\[/) {
        print '8=,`';
        $program = substr($program,1);
    } elsif ($program =~ /^]/) {
        print '`,=>';
        $program = substr($program,1);
    } else {
        print STDERR "bad input\n";
        $program = substr($program,1);
    }
}

print "\n";
