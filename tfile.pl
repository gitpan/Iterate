#!/usr/bin/perl

use warnings;
use strict;

use Data::Dumper;

use Iterate;

# open this file, grep for a string, map all lines that match and return
# into array of results to process later.


my @map = IterFile "tfile.pl", sub
	{
	# the line read from the file is stored in $_[0]
	my $line = $_[0];
	chomp($line);

	# the current line number corresponding to $_[0] is stored in $_[-1]
	my $number = $_[-1];

	if($line =~ /number/)
		{ return ($number .": ".$line); }
	else
		{return;}

	};

print Dumper \@map;
