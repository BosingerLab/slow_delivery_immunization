#!/usr/bin/perl -w
use strict;

open IN,"../../../index.txt" or die $!;
while(my $ln = <IN>)
{
  my @arr = split(" ",$ln);
  open OUT,">$arr[0]\_FP.fasta" or die $!;
  $arr[2]=~/(\S+)/;
  $arr[2] = $1;
  $arr[2]=~s/N//g;
  print OUT ">$arr[0]\n$arr[2]AAGCAGTGGTATCAACGCAGAGT\n";
}

