#!/usr/bin/perl
use strict;
use warnings;
use lib 'lib';
use Test::More tests => 2;
use List::Merge;

sub seq {
	my ( $mult, $max ) = @_;
	map { $_ * $mult } 1 .. int( $max / $mult );
}

sub x {
	my $max = pop;
	join ' ',
		merge { $_[0] <=> $_[1] }
		map [ seq $_, $max ], @_
}

is x( 3, 5, 100 ), '3 5 6 9 10 12 15 18 20 21 24 25 27 30 33 35 36 39 40 42 45 48 50 51 54 55 57 60 63 65 66 69 70 72 75 78 80 81 84 85 87 90 93 95 96 99 100';
is x( 3, 7, 100 ), '3 6 7 9 12 14 15 18 21 24 27 28 30 33 35 36 39 42 45 48 49 51 54 56 57 60 63 66 69 70 72 75 77 78 81 84 87 90 91 93 96 98 99';
