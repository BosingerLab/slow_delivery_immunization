#!/usr/bin/perl -w
use strict;

open IN,"$ARGV[0]" or die $!;
while(my $ln = <IN>)
{
	chomp $ln;
	my ($gene,$fr1s,$fr1e,$cdr1s,$cdr1e,$fr2s,$fr2e,$cdr2s,$cdr2e,$fr3s,$fr3e,$chain,$frame) = split("\t",$ln);
	$fr1s = $fr1s;
	$fr1e = $fr1e * 3;
	$cdr1s = $fr1e + 1;
	$cdr1e = $cdr1e * 3;
	$fr2s = $cdr1e + 1;
	$fr2e = $fr2e * 3;
	$cdr2s = $fr2e + 1;
	$cdr2e = $cdr2e * 3;
	$fr3s = $cdr2e + 1;
	$fr3e = $fr3e * 3;

	print "$gene\t$fr1s\t$fr1e\t$cdr1s\t$cdr1e\t$fr2s\t$fr2e\t$cdr2s\t$cdr2e\t$fr3s\t$fr3e\t$chain\t$frame\n";
}