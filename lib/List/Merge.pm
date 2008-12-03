#!/usr/bin/perl
use strict;

package List::Merge;

use Exporter::Tidy default => [ qw( merge ) ];

my ( $peek, $take, $drop, $empty ) = ( 0 .. 20 );

my $make_stream = sub {
	my $array = shift;
	my $i = 0;
	my @o;
	$o[ $peek  ] = sub { $array->[ $i ] };
	$o[ $take  ] = sub { $array->[ $i++ ] };
	$o[ $drop  ] = sub { ++$i };
	$o[ $empty ] = sub { $i > $#$array ? 1 : 0 };
	return \@o;
};

sub merge(&@) {
	my $comparator = shift;
	my @stream = map $make_stream->( $_ ), @_;

	my @ret;

	while ( @stream > grep $_->[$empty](), @stream ) {

		my @ranked = sort {
			my $is_a_exh = $a->[$empty]();
			my $is_b_exh = $b->[$empty]();

			$is_a_exh || $is_b_exh
				? $is_a_exh - $is_b_exh
				: $comparator->( $a->[$peek](), $b->[$peek]() );

		} @stream;

		my $taken = ( shift @ranked )->[$take]();

		for my $stream ( @ranked ) {
			next if $stream->[$empty]();
			last if $comparator->( $taken, $stream->[$peek]() );
			$stream->[$drop]();
		}

		push @ret, $taken;
	}

	return @ret;
}

1;
