#!/usr/bin/perl -w
use strict;

#IGH & IGK
# FR1-IMGT  CDR1-IMGT  FR2-IMGT  CDR2-IMGT  FR3-IMGT   CDR3-IMGT    FR4-IMGT  
# (1-26)    (27-38)    (39-55)   (56-65)    (66-104)   (105-117)    (118-128)

# IGL
# FR1-IMGT  CDR1-IMGT  FR2-IMGT  CDR2-IMGT  FR3-IMGT
# (1-27)    (28-39)    (40-58)   (59-68)    (69-107)

open IN,"$ARGV[0]" or die $!;
my $head;
my $seq;
while(my $ln=<IN>)
{
  chomp $ln;  
  if($ln=~/>(.*)/)
  {
    $head = $1;

    $ln=<IN>;
    chomp $ln;

    # my @seq = split("",$ln);
    # my @fr1 = @seq[0..25]; 
    # my @cdr1 = @seq[26..37];
    # my @fr2  = @seq[38..54];
    # my @cdr2 = @seq[55..64];
    # my @fr3  = @seq[65..103];

    my @seq = split("",$ln);
    my @fr1 = @seq[0..26]; 
    my @cdr1 = @seq[27..38];
    my @fr2  = @seq[39..57];
    my @cdr2 = @seq[58..67];
    my @fr3  = @seq[68..106];

    my($fr1_s,$fr1_e) = positions(0,\@fr1);
    #print "FR1 $head\t@fr1\t$fr1_s\t$fr1_e\n";
   
    my($cdr1_s,$cdr1_e) = positions($fr1_e,\@cdr1);
    #print "CDR1 $head\t@cdr1\t$cdr1_s\t$cdr1_e\n";
    
    my($fr2_s,$fr2_e) = positions($cdr1_e,\@fr2);
    #print "FR2 $head\t@fr2\t$fr2_s\t$fr2_e\n";

    my($cdr2_s,$cdr2_e) = positions($fr2_e,\@cdr2);
    #print "CDR2 $head\t@cdr2\t$cdr2_s\t$cdr2_e\n";

    my($fr3_s,$fr3_e) = positions($cdr2_e,\@fr3);
    #print "FR3 $head\t@fr3\t$fr3_s\t$fr3_e\n\n";

    my $chain = '';
    $head=~/IG(.)V/;
    $chain = $1;

    print "$head\t$fr1_s\t$fr1_e\t$cdr1_s\t$cdr1_e\t$fr2_s\t$fr2_e\t$cdr2_s\t$cdr2_e\t$fr3_s\t$fr3_e\tV$chain\t0\n";
  }
}

sub positions
{
  my ($end,$arr) = @_;
  my $s;
  my $e=0;
  
  $s = $end + 1;
  foreach my $aa(@{$arr})
  {
    if($aa ne ".")
    {
      $e++;
    }
  }
  $e = ($s + $e) - 1;
  return ($s,$e);
}
