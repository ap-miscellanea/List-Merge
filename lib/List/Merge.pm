#!/usr/bin/perl
use strict;

package List::Merge;

use Exporter::Tidy default => [ qw( merge ) ];

my $empty = sub { local *_ = shift; $_[1] > $#{$_[0]} ? 1 : 0 };
my $peek  = sub { local *_ = shift; $_[0][$_[1]] };
my $drop  = sub { local *_ = shift; $_[1]++ };
my $take  = sub { my $val = $peek->( $_[0] ); $drop->( $_[0] ); $val };

sub merge(&@) {
	my $comparator = shift;
	my @stream = map [ $_, 0 ], @_;

	my @ret;

	while ( @stream > grep $empty->( $_ ), @stream ) {

		my @ranked = sort {
			my $is_a_exh = $empty->( $a );
			my $is_b_exh = $empty->( $b );

			$is_a_exh || $is_b_exh
				? $is_a_exh - $is_b_exh
				: $comparator->( $peek->( $a ), $peek->( $b ) );

		} @stream;

		my $taken = $take->( shift @ranked );

		for my $s ( @ranked ) {
			next if $empty->( $s );
			last if $comparator->( $taken, $peek->( $s ) );
			$drop->( $s );
		}

		push @ret, $taken;
	}

	return @ret;
}

1;
