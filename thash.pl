#!/usr/bin/perl

use warnings;
use strict;

use Data::Dumper;

use Iterate;

my %hash = 
	(
	blue => 'moon',
	green => 'egg',
	red => 'baron',
	);


print Dumper \%hash;


# doing a nested iteration, note this example needs to 
# have parens () around the hash and coderef that are 
# parameters to the IterHash subroutine call.

IterHash (%hash, sub
	{
	# $_[0] is the current key
	# $_[1] is the current value

	my $key1 = $_[0];
	my $val1 = $_[1];

	print "checking key1 $key1, val1 $val1 for collisions \n";

	IterHash (%hash, sub
		{
		my $key2 = $_[0];
		my $val2 = $_[1];

		print "\tchecking key2 $key2, val2 $val2 for collisions \n";

		print "\t $val2 is not $key1\n"
			unless($key1 eq $key2);
		return;
		});

	});


my @map = IterHash %hash, sub
	{
	my $key1 = $_[0];
	my $val1 = $_[1];

	if($key1 =~ /\w\we/)
		{ return ($key1, $val1); }
	else
		{return;}

	};

print Dumper \@map;
