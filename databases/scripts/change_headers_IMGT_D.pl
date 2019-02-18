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
open OUT,">$ARGV[0]\_imgt.fa" or die $!;
while(my $ln = <IN>)
{
	chomp $ln;
	if($ln=~/>(.*)/)
	{
		chomp $ln;
		my $head = $1;
		$head=~s/\./-/;
		$ln=<IN>;
		chomp $ln;
		my $ungap = $ln;
		$ungap=~s/\.//g;

		my $len = length($ln);
                #print "$len-$ln-\n";     
     	 	my $gaps = () = $ln =~ /\./g;
      		my $nuc = $len-$gaps;

      		# print OUT ">$head|$head|Macaca mulatta|F|J-REGION|0..0|$nuc nt|1| | | | |$nuc+$gaps=$len| | | |\n$ln\n";		
      		print OUT ">$head|$head|Macaca mulatta|F|D-REGION|0..0|$nuc nt|1| | | | |$nuc+$gaps=$len| | | |\n$ln\n";
	}
}

close IN;
close OUT;
