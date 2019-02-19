#!/usr/bin/perl -w
use strict;

my %fastq;
open IN,"../list_fastq" or die $!;
while(my $ln = <IN>)
{
  chomp $ln;
  $ln=~/(.*?)_.*/;
  $fastq{$1} = $ln;
}
close IN;

open IN,"../index.txt" or die $!;
while(my $ln = <IN>)
{
  chomp $ln;
  my ($sample,$barcode,$inline) = split(" ",$ln);
  my $file = $fastq{$barcode};
  $file=~s/R1_001/R2_001/;
 
  system "seqtk subseq ../$file $sample\_R1_001_reads > $sample\_R2_001.fastq\n"; 
}

