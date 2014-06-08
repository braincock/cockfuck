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
# cockfuck.pl - cockfuck interpreter
#

no warnings 'uninitialized';
use strict;

if ($ARGV[0] eq "") {
    print "Usage: $0 <cockfile>\n";
    exit(-1);
}

my $file;
open($file, $ARGV[0]) or die "Couldn't open input cockfile: $!";
my $program = join('',<$file>);
close $file;
undef $file;

my @commands;

# commands
my $dataInc = 1;
my $dataDec = 2;
my $ptrInc =  3;
my $ptrDec =  4;
my $takeIn =  5;
my $putOut =  6;
my $jmpFwd =  7;
my $jmpBack = 8;

# cockfuck
#
# a brainfuck implementation with ascii cocks
#
# in all of the below, "length of cock" refers to the number of unit shafts (=). The penis and glans are irrelevant.
#
# 8=====>      increment data pointer by length of cock
# 8=====D      decrement data pointer by length of cock
#
# B=====>      increase the byte at the data pointer by length of cock
# B=====D      decrease the byte at the data pointer by length of cock
#
# -            accept one byte of input (sound)
# ~            produce one byte of output (jizz)
#
# 8=,          if current data is zero, jump forward to matching choptiglans (length of cock does not matter)
# `=>          if the current data is nonzero, jump backward to matching choptiballs (length of cock does not matter)
#
# a valid cockfuck program contains only the above characters, so we get rid of everything else:

$program =~ s/[^8=>DB\-~'`,]//gs;

# add a command and remove it from the front of the program
sub addCommand {
    my $command = shift @_;
    my $len = shift @_;
    my $num = shift @_;
    $num ||= $len - 2;

    push( @commands, [$command, $num] );
    $program = substr($program, $len);
}

my @lastcock;
# now, read the program into the command buffer
while (length($program) > 0) {
    if      ($program =~ /^(B=+>)/) {
        addCommand($dataInc,length($1));
    } elsif ($program =~ /^(B=+D)/) {
        addCommand($dataDec,length($1));
    } elsif ($program =~ /^(8=+>)/) {
        addCommand($ptrInc,length($1));
    } elsif ($program =~ /^(8=+D)/) {
        addCommand($ptrDec,length($1));
    } elsif ($program =~ /^(-+)/) {
        addCommand($takeIn,length($1),length($1));
    } elsif ($program =~ /^(~+)/) {
        addCommand($putOut,length($1),length($1));
    } elsif ($program =~ /^(8=+,)/) {
        addCommand($jmpFwd,length($1));
        push(@lastcock,$#commands);
    } elsif ($program =~ /^(`=+>)/) {
        my $lstck = pop(@lastcock);
        unless (defined($lstck)) {
            print STDERR "Error: unbalanced chopticock! Program is invalid.\n";
            exit(-1);
        } else {
            $program = substr($program, length($1));
            push( @commands, [$jmpBack, $lstck] );
            # fix the forward reference from lastcock
            ${$commands[$lstck]}[1] = $#commands;
        }
    } else {
        # if this command is invalid, just skip to the next byte and try
        # interpreting again
        print STDERR "Warning: invalid cocksequence detected. Skipping...\n";
        $program = substr($program,1);
    }
}

if ($#lastcock >= 0) {
    print STDERR "Error: unbalanced chopticock! Program is invalid.\n";
    exit(1);
}
undef @lastcock;
undef $program;

my $pointer = 0;
my @array;

my $cmd = 0;

while ($cmd <= $#commands) {
    my ($command, $number) = @{$commands[$cmd]};

    if ($command == $dataInc) {
        $array[$pointer] += $number;
        $array[$pointer] %= 256;
    } elsif ($command == $dataDec) {
        $array[$pointer] -= $number;
        $array[$pointer] %= 256;
    } elsif ($command == $ptrInc) {
        $pointer += $number;
        $pointer %= 65536;
    } elsif ($command == $ptrDec) {
        $pointer -= $number;
        $pointer %= 65536;
    } elsif ($command == $takeIn) {
        my $tmpvar;
        read(STDIN, $tmpvar, $number);
        $array[$pointer] = ord(substr($tmpvar, $number - 1));
    } elsif ($command == $putOut) {
        print chr($array[$pointer]) x $number;
    } elsif ($command == $jmpFwd) {
        if ($array[$pointer] == 0) {
            $cmd = $number;
        }
    } elsif ($command == $jmpBack) {
        if ($array[$pointer] != 0) {
            $cmd = $number;
        }
    }

    $cmd++;
}
