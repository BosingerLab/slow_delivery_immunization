#!/usr/bin/perl -w
use strict;

# The IMGT/GENE-DB FASTA header contains 15 fields separated by '|':

#1. IMGT/LIGM-DB accession number(s)
#2. gene and allele name
#3. species
#4. functionality
#5. exon(s), region name(s), or extracted label(s)
#6. start and end positions in the IMGT/LIGM-DB accession number(s)
#7. number of nucleotides in the IMGT/LIGM-DB accession number(s)
#8. codon start, or 'NR' (not relevant) for non coding labels
#9. +n: number of nucleotides (nt) added in 5' compared to the corresponding label extracted from IMGT/LIGM-DB
#10. +n or -n: number of nucleotides (nt) added or removed in 3' compared to the corresponding label extracted from IMGT/LIGM-DB
#11. +n, -n, and/or nS: number of added, deleted, and/or substituted nucleotides to correct sequencing errors, or 'not corrected' if non corrected sequencing errors
#12. number of amino acids (AA): this field indicates that the sequence is in amino acids
#13. number of characters in the sequence: nt (or AA)+IMGT gaps=total
#14. partial (if it is)
#15. reverse complementary (if it is)

open IN,"$ARGV[0]" or die $!;
open OUT,">$ARGV[0]\_imgt_nucl_gapped.fa" or die $!;
open OUT1,">$ARGV[0]\_imgt_nucl_gapped_imgtheaders.fa" or die $!;
open OUT2,">$ARGV[0]\_imgt_nucl_ungapped.fa" or die $!;
while(my $ln = <IN>)
{
	chomp $ln;
	if($ln=~/>(.*)/)
	{
		my $head = $1;
		$head=~/LJI.Rh_(.*)/;	
		$head="$1*01";
		$head=~s/\./-/;
		print OUT ">$head\n";
		print OUT2 ">$head\n";
		$ln=<IN>;
		chomp $ln;
		$ln=~/(.*\w)\.+$/;
		print "$1\n";
		$ln=$1;
		print OUT $ln;

		my $ungap = $ln;
		$ungap=~s/\.//g;
		print OUT2 $ungap;		

		my $len = length($ln);
      	my $gaps = () = $ln =~ /\./g;
      	my $nuc = $len-$gaps;

      	print OUT1 ">$head|$head|Macaca mulatta|F|V-REGION|0..0|$nuc nt|1| | | | |$nuc+$gaps=$len| | | |\n$ln\n";
		
	}
}

close IN;
close OUT;
close OUT1;
close OUT2;
