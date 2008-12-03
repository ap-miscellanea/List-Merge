#!/usr/bin/perl
use strict;

package List::Merge;

use Exporter::Tidy default => [ qw( merge ) ];

sub merge(&@) {
	my $comparator = shift;
	my @idx = (0) x @_;

	my @ret;

	while ( @_ > grep { $idx[$_] > $#{$_[$_]} } 0 .. $#_ ) {

		my @ranked = sort {
			my $is_a_exh = $idx[$a] > $#{$_[$a]} ? 1 : 0;
			my $is_b_exh = $idx[$b] > $#{$_[$b]} ? 1 : 0;

			$is_a_exh || $is_b_exh
				? $is_a_exh - $is_b_exh
				: $comparator->( $_[$a][$idx[$a]], $_[$b][$idx[$b]] );

		} 0 .. $#_;

		my $taken = $_[$ranked[0]][$idx[$ranked[0]]];

		for my $i ( @ranked ) {
			next if $idx[$i] > $#{$_[$i]};
			last if $comparator->( $taken, $_[$i][$idx[$i]] );
			$idx[$i]++;
		}

		push @ret, $taken;
	}

	return @ret;
}

1;
