#!/usr/bin/perl
use strict;

my %aacode = (
  TTT => "F", TTC => "F", TTA => "L", TTG => "L",
  TCT => "S", TCC => "S", TCA => "S", TCG => "S",
  TAT => "Y", TAC => "Y", TAA => "*", TAG => "*",
  TGT => "C", TGC => "C", TGA => "*", TGG => "W",
  CTT => "L", CTC => "L", CTA => "L", CTG => "L",
  CCT => "P", CCC => "P", CCA => "P", CCG => "P",
  CAT => "H", CAC => "H", CAA => "Q", CAG => "Q",
  CGT => "R", CGC => "R", CGA => "R", CGG => "R",
  ATT => "I", ATC => "I", ATA => "I", ATG => "M",
  ACT => "T", ACC => "T", ACA => "T", ACG => "T",
  AAT => "N", AAC => "N", AAA => "K", AAG => "K",
  AGT => "S", AGC => "S", AGA => "R", AGG => "R",
  GTT => "V", GTC => "V", GTA => "V", GTG => "V",
  GCT => "A", GCC => "A", GCA => "A", GCG => "A",
  GAT => "D", GAC => "D", GAA => "E", GAG => "E",
  GGT => "G", GGC => "G", GGA => "G", GGG => "G",
); # this is the hash table for the amino acids



my %sequences;

# Read nucleotide sequences

open IN,"$ARGV[0]" or die $!;
my $head='';
my $seq='';
while(my $ln = <IN>)
{
  chomp $ln;
  if($ln=~/>(.*)/)
  {
    $head = $1;
    $ln=<IN>;
    chomp $ln;
    #print "$head\t$ln\n";
    $sequences{$head}{'nucl'}=$ln;

    my (@f1_arr,@f2_arr,@f3_arr);    

    for(my $i=0,my $j=1,my $k=2;$i<length($ln);$i+=3,$j+=3,$k+=3)
    {
      my $f1 = substr($ln,$i,3);
      push @f1_arr,$aacode{$f1};

      my $f2 = substr($ln,$j,3);
      push @f2_arr,$aacode{$f2};

      my $f3 = substr($ln,$k,3);
      push @f3_arr,$aacode{$f3};
    }
    $sequences{$head}{'1'} = join "",@f1_arr;
    $sequences{$head}{'2'} = join "",@f2_arr;
    $sequences{$head}{'3'} = join "",@f3_arr;

    #print "$head\n1\n$sequences{$head}{'1'}\n2\n$sequences{$head}{'2'}\n3\n$sequences{$head}{'3'}\n";
  }
}
close IN;

# Read protein sequences

my %index;
my %index1;
open IN,"$ARGV[1]" or die $!;
while(my $ln =<IN>)
{
  my ($head,$id) = split(" ",$ln);
  $index{$id} = $head;
  $head=~/(.*)_1/;
  $head=$1;
  $index1{$head} = $id;
}
close IN;

open IN,"$ARGV[2]" or die $!;
while(my $ln = <IN>)
{
  chomp $ln;

  $ln=~/(\S+)\s+(\S+)/;
  my $aahead = $index{$1};
  my $seq = $2;

  $aahead=~/(.*)_1/;
  $aahead=$1;
  
  my $ungapped=$seq;
  $ungapped=~s/\.//g;
  #print "$aahead\t$seq\n";

  $sequences{$aahead}{'aa'} = $seq;
  $sequences{$aahead}{'ungapped'} = $ungapped;
  my $len_aa = length($ungapped);
  my $len_nucl = $len_aa * 3;

  # Extract nucleotide sequence matching the gapped aligned sequence from DGA

  for(my $i=1;$i<4;$i++)
  {

    my $start = index($sequences{$aahead}{$i},$ungapped);
    my $equal='';
    if($sequences{$aahead}{$i} eq $ungapped){$equal="TRUE";}
    # print "$aahead $i $start $equal $len_aa $len_nucl\n";
    if($start > -1)
    {
      my $end = $start + $len_aa;
      my $n_start = ( ($start * 3) + ($i-1));
      my $n_seq = $sequences{$aahead}{'nucl'};
      $n_seq=~/.{$n_start}(.{$len_nucl})/;
      $n_seq = $1;
      $sequences{$aahead}{'new_nucl'} = $n_seq;
      # print "$aahead $i $start $end $len_aa $len_nucl\n$ungapped\n$sequences{$aahead}{$i}\n$n_seq\n$sequences{$aahead}{'nucl'}\n";
      last;
      
    }
    else
    {
      $sequences{$aahead}{'new_nucl'} = "NA";
    }
  }
}
close IN;


# Get gapped nucleotide and protein 

open OUT1,">$ARGV[0]\_gapped_nucl.fa" or die $!;
open OUT2,">$ARGV[0]\_gapped_prot.fa" or die $!;

foreach my $h(sort keys %sequences)
{
  if(!($sequences{$h}{'aa'} && $sequences{$h}{'nucl'}))
  {
    print "$h $index1{$h} failed\n";
    next;
  }

  print OUT1 ">$h\n";
  my $len_aa = length($sequences{$h}{'aa'});
  my $len_nucl = length($sequences{$h}{'new_nucl'});

  my @aa = split('',$sequences{$h}{'aa'});

  #print "@aa\n$sequences{$h}{'nucl'}\n";

  if($len_nucl == 2)
  {
    print "Check\t$h\t$index1{$h}\n$sequences{$h}{'aa'}\n$sequences{$h}{'nucl'}\nO:$sequences{$h}{'ungapped'}\n1:$sequences{$h}{'1'}\n2:$sequences{$h}{'2'}\n3:$sequences{$h}{'3'}\n";
  }


  my @codons;
  my $nucl = $sequences{$h}{'new_nucl'};
  for(my $i=0;$i<length($nucl);$i+=3)
  {
    my $str = substr($nucl,$i,3);
    push(@codons,$str);
  }

 
  my $ j = 0;
  for(my $i=0; $i < $len_aa; $i++)
  {
    if($aa[$i] eq '.')
    {
      #print "$aa[$i] <=> ...\n";
      print OUT1 "...";
    }
    elsif($aacode{$codons[$j]} eq $aa[$i])
    {
      #print "$aa[$i] <=> $codons[$j]\n";
      print OUT1 "$codons[$j]";
      $j++;
    }
    else
    {
      print "No match: $h $codons[$j]: $aacode{$codons[$j]} vs $aa[$i]\n";
      last;
    }

  }
  print OUT1 "\n";
  print OUT2 ">$h\n$sequences{$h}{'aa'}\n";
}





