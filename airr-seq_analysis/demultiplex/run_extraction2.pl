#!/usr/bin/perl -w
use strict;

my %fastq;
open IN,"list_fastq" or die $!;
while(my $ln = <IN>)
{
  chomp $ln;
  $ln=~/(.*?)_.*/;
  $fastq{$1} = $ln;
}
close IN;

open IN,"index.txt" or die $!;
while(my $ln = <IN>)
{
  chomp $ln;
  my ($sample,$barcode,$inline) = split(" ",$ln);
  my $N = $inline =~ tr/N//;
  $inline =~ s/N//g;

  my $file = $fastq{$barcode};
  system "./extract_inline2.pl $file $inline $sample $N\n";
}



