#!/usr/bin/perl

use warnings;
use strict;

use Data::Dumper;

use Iterate;

my @array = qw (alpha bravo charlie delta echo);


my @map = IterArray @array, sub
	{
	# $_[1] is the current index
	if($_[1] == 3)
		{
		# modify the element in the original array
		$_[0] = 'three'; 
		}

	# $_[0] is the original scalar in the iterated array
	my $ret =  ($_[0]).' break ';
	return ($ret, ',');
	};

print Dumper \@array;

print Dumper \@map;
