package Iterate;


=for
    Iterate - Smart, Simple, Recursive Iterators for Perl programming.
    Copyright (C) 2002  Greg London

    This program is free software; you can redistribute it and/or modify
    it under the same terms as Perl 5 itself.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    Perl 5 License schemes for more details.

    contact the author via http://www.greglondon.com
=cut


require 5.005_62;
use strict;
use warnings;

use Carp;

require Exporter;

our @ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

our @EXPORT = qw(

	IterArray
	IterHash
	IterFile
	
);
our $VERSION = '0.01';



##############################################################################
sub IterArray(\@&)
##############################################################################
{
	my $arrayref = shift(@_);
	my $callback = shift(@_);

	my $index;
	my @return;

	my $wantarray = (defined(wantarray()) and wantarray()) ? 1 : 0;
	#print "wantarray is $wantarray \n";

	for(my $index=0; $index<scalar(@$arrayref); $index++)
		{
		if($wantarray)
			{
			push(@return, $callback->($arrayref->[$index], $index));
			}
		else
			{
			$callback->($arrayref->[$index], $index);
			}
		}
	if($wantarray)
		{ return (@return); }
	else
		{return;}}



##############################################################################
sub IterHash(\%&)
##############################################################################
{
	my $hashref = shift(@_);
	my $callback = shift(@_);

	my $arrayref = [keys(%$hashref)];
	my $index;
	my @return;

	my $wantarray = (defined(wantarray()) and wantarray()) ? 1 : 0;
	#print "wantarray is $wantarray \n";

	for(my $index=0; $index<scalar(@$arrayref); $index++)
		{
		if($wantarray)
			{
			push(@return, $callback->($arrayref->[$index], $hashref->{$arrayref->[$index]}, $index));
			}
		else
			{
			$callback->($arrayref->[$index], $hashref->{$arrayref->[$index]}, $index);
			}
		}

	if($wantarray)
		{ return (@return); }
	else
		{return;}
}



##############################################################################
sub IterFile($&)
##############################################################################
{
	my $filename = shift(@_);
	my $callback = shift(@_);

	my @return;

	my $wantarray = (defined(wantarray()) and wantarray()) ? 1 : 0;
	#print "wantarray is $wantarray \n";

	open ( my $filehandle, $filename ) or croak "Error: cannot open $filename";

	my $linenumber=0;
	while(<$filehandle>)
		{
		$linenumber++;
		if($wantarray)
			{
			push(@return, $callback->($_, $linenumber));
			}
		else
			{
			$callback->($_, $linenumber);
			}
		}

	close($filehandle) or croak "Error: cannot close $filename";
	if($wantarray)
		{ return (@return); }
	else
		{return;}	
}


1;
__END__

=head1 NAME

    Iterate - Smart, Simple, Recursive Iterators for Perl programming.

=head1 SYNOPSIS

  use Iterate;

  # iterate an array, at index 3, change the value in the array to "three"
  my @array = qw (alpha bravo charlie delta echo);

  IterArray @array, sub
	{
	# $_[1] is the current numeric index
	if($_[1] == 3)
		{
		# modify the element in the original array
		$_[0] = 'three'; # current element available via $_[0]
		}
	}


  # iterate a hash, perform nested iteration on the same hash.

  my %hash = 
	(
	blue => 'moon',
	green => 'egg',
	red => 'baron',
	);
 
  IterHash (%hash, sub
	{
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

  # iterate a file, read it line by line, and grep for a string.
  IterFile "tfile.pl", sub
	{
	# the line read from the file is stored in $_[0]
	my $line = $_[0];

	# the current line number corresponding to $_[0] is stored in $_[-1]
	my $number = $_[-1];

	if($line =~ /search/)
		{
		print "found at line $number: $line";
		}
	};



=head1 DESCRIPTION

This module is intended to demonstrate a simple way to implement
iterators on perl variables with little code required of the 
programmer using them.

Some additional advantages over standard perl iterators:

Array iterators give access to the current index within the array.
Hash iterators can be nested upon the same hash without conflicts.
File iterators allow simple file munging in a few lines of code.

=head2 EXPORT

	IterArray
	IterHash
	IterFile

=head1 AUTHOR

    Iterate - Smart, Simple, Recursive Iterators for Perl programming.
    Copyright (C) 2002  Greg London

    This program is free software; you can redistribute it and/or modify
    it under the same terms as Perl 5 itself.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    Perl 5 License schemes for more details.

    contact the author via http://www.greglondon.com


=head1 SEE ALSO

perl(1).

=cut
