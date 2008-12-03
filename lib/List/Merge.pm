#!/usr/bin/perl
use strict;

package List::Merge;

use Exporter::Tidy default => [ qw( merge ) ];

sub merge(&@) {
	my $comparator = shift;
	my @stream = map [ $_, 0 ], @_;

	my @ret;

	while ( @stream > grep { $_->[1] > $#{$_->[0]} } @stream ) {

		my @ranked = sort {
			my $is_a_exh = $a->[1] > $#{$a->[0]} ? 1 : 0;
			my $is_b_exh = $b->[1] > $#{$b->[0]} ? 1 : 0;

			$is_a_exh || $is_b_exh
				? $is_a_exh - $is_b_exh
				: $comparator->( $a->[0][$a->[1]], $b->[0][$b->[1]] );

		} @stream;

		my $taken = $ranked[0][0][$ranked[0][1]];

		for my $s ( @ranked ) {
			next if $s->[1] > $#{$s->[0]};
			last if $comparator->( $taken, $s->[0][$s->[1]] );
			$s->[1]++;
		}

		push @ret, $taken;
	}

	return @ret;
}

1;
