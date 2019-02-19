**AIRR-Seq analysis**

1. The samples were first demutiplexed using the Illumina bcl2fastq tools using

   `bcl2fastq --sample-sheet samplesheet.csv -o Unaligned --barcode-mismatches 0`
 
2. The run_extraction2.pl and extract_inline2.pl scripts were used to demultiplex samples to get Read1 files based on barcodes specified    in index.txt.

3. get_R2.pl script (uses seqtk[1]) used to get Read2 file. 

4. FastQC v0.11.5 [2] was used to check the quality of fastq files.

5. pRESTO [3] used for pre-processing.

6. Assemble: Reads assembled using AssemblePairs.py (v0.5.6)
   
   `AssemblePairs.py align -1 <Read1.fastq> -2 <Read2.fastq> --coord illumina --nproc 2 --rc tail --outname <output> --log <log file>`

7. Filter: Reads mean quality score of less than 20 filtered using FilterSeq.py (v0.5.6)

   `FilterSeq.py quality -s <input> -q 20 --outname <output> --log <log file>`

8. Mask primers: MaskPrimers (v0.5.6) tool used to remove the forward primers and the random nucleotides from the assembled sequences

   `MaskPrimers.py score -s <input> -p <primer.fasta> --start <start> --mode cut --outname <output> --log <log file>`

9. Parse headers

   `ParseHeaders.py expand -s <input> -f PRIMER`

10. Parse headers

    `ParseHeaders.py rename -s <input> -f PRIMER1 -k VPRIMER --outname <out>`
   
11. Concatenate technical replicates

12. Remove duplicates and get DUPCOUNT for each unique sequence using CollapseSeq (v0.5.8)

    `CollapseSeq.py -s <input> -n 20 --inner --cf VPRIMER --act set --outname <output> --log <log file>`

13. Filter sequences with DUPCOUNT < 2: SplitSeq (v0.5.8)

    `SplitSeq.py group -s <input> -f DUPCOUNT --num 2 --outname <output>`

14. Create annotation table

    `ParseHeaders.py table -s <input>  -f ID DUPCOUNT VPRIMER --outname <output>`

15. The pre-processed sequences were then annotated using IgBLAST v1.6.1 [4].

    ```
    seqtk seq -a <input.fastq> > <fasta>
    
    igblastn -germline_db_V <V database> -germline_db_J <J_database> -germline_db_D <D database> 
    -organism rhesus_monkey -domain_system imgt -ig_seqtype Ig -query <fasta> -auxiliary_data <optional file> \
    -outfmt '7 std qseq sseq btop' -out IgBLAST/<blastout> -clonotype_out IgBLAST/clonotype/<clontype output>
    ```

16. Make database from IgBLAST using MakeDb.py from ChangeO 0.4.1 [5]

    ```
    MakeDb.py igblast -i <blastout> -s <fasta> -r IGH[VDJ].fa --regions --scores --cdr3 --outname <output>
    MakeDb.py igblast -i <blastout> -s <fasta> -r IGK[VJ].fa --regions --scores --cdr3 --outname <output>
    MakeDb.py igblast -i <blastout> -s <fasta> -r IGL[VJ].fa --regions --scores --cdr3 --outname <output>
    ```

17. Get Functional sequences

    `ParseDb.py split -d <input>  -f FUNCTIONAL --outname <output>`

18. Clonal assignment using get_clonotype.pl. Sequences are assigned to the same clonal family if they have: 
      (i) same V gene, 
     (ii) same J gene,
    (iii) same CDR3 length
     (iv) CDR3 nucleotide identity > 0.85
 
19. Create germlines:
    ```
    CreateGermlines.py -d <input> -g dmask -r IGH[VDJ].fa --outdir Germlines
    CreateGermlines.py -d <input> -g dmask -r IGK[VJ].fa --outdir Germlines
    CreateGermlines.py -d <input> -g dmask -r IGL[VJ].fa --outdir Germlines
    ```
20. Mutations determined by observedMutations function from alakazam 0.2.10 and shazam 0.1.9 packages.

    `observedMutations(db_obs, sequenceColumn="SEQUENCE_IMGT",
                              germlineColumn="GERMLINE_IMGT_D_MASK",
                              regionDefinition=NULL,
                              frequency=TRUE, combine = TRUE`                          `

21. Diversity indices were determined using get_diversity_index.R (uses vegan [6] package) that reads the clonal abundance obtained from     `countClones(db,copy="DUPCOUNT")` function in the alakazam package


References:
1. https://github.com/lh3/seqtk/
2. Andrews S: FastQC: a quality control tool for high throughput sequence data. 2010.
3. Vander Heiden JA, Yaari G, Uduman M, Stern JN, O'Connor KC, Hafler DA, Vigneault F, Kleinstein SH: pRESTO: a toolkit for processing high-throughput sequencing raw reads of lymphocyte receptor repertoires. Bioinformatics 2014, 30:1930-1932.
4. Ye J, Ma N, Madden TL, Ostell JM: IgBLAST: an immunoglobulin variable domain sequence analysis tool. Nucleic Acids Res 2013, 41:W34-40.
5. Gupta NT, Vander Heiden JA, Uduman M, Gadala-Maria D, Yaari G, Kleinstein SH: Change-O: a toolkit for analyzing large-scale B cell immunoglobulin repertoire sequencing data. Bioinformatics 2015, 31:3356-3358.
6. Oksanen J, Blanchet FG, Kindt R, Legendre P, Minchin PR, O’hara R, Simpson GL, Solymos P, Stevens MHH, Wagner H: Package ‘vegan’. Community ecology package, version 2013, 2.
