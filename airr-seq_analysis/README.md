AIRR-Seq analysis


Illumina bcl files from IgG, IgK and IgL amplicons were converted to fastq files using the bcl2fastq tool. FastQC v0.11.5 [1] was used to check the quality of fastq files. The repertoire sequence analysis was carried out using the pRESTO, Change-O 0.4.1, Alakazam 0.2.10 and SHazaM 0.1.9 packages from the Immcantation pipeline [2, 3]. Pre-processing was performed using tools in the pRESTO package. Paired-end reads were first assembled with AssemblePairs (v0.5.6) tool. Reads with a mean quality score of less than 20 were filtered out using FilterSeq (v0.5.6). The MaskPrimers (v0.5.6) tool was used to remove the forward primers and the random nucleotides from the assembled sequences. Data from each of the two technical replicates was combined. Duplicates were removed and the duplicate counts were obtained for each unique sequence using CollapseSeq (v0.5.8). SplitSeq (v0.5.8) was used to select sequences that had duplicate counts of at least two to eliminate singletons that may arise due to sequencing errors. The pre-processed sequences were then annotated using IgBLAST v1.6.1 [4]. 


References Cited

1.	Andrews S: FastQC: a quality control tool for high throughput sequence data. 2010.
2
3.	Gupta NT, Vander Heiden JA, Uduman M, Gadala-Maria D, Yaari G, Kleinstein SH: Change-O: a toolkit for analyzing large-scale B cell immunoglobulin repertoire sequencing data. Bioinformatics 2015, 31:3356-3358.
4.	Vander Heiden JA, Yaari G, Uduman M, Stern JN, O'Connor KC, Hafler DA, Vigneault F, Kleinstein SH: pRESTO: a toolkit for processing high-throughput sequencing raw reads of lymphocyte receptor repertoires. Bioinformatics 2014, 30:1930-1932.
5.	Ye J, Ma N, Madden TL, Ostell JM: IgBLAST: an immunoglobulin variable domain sequence analysis tool. Nucleic Acids Res 2013, 41:W34-40.
6.	Lefranc M-P, Lefranc G: The immunoglobulin factsbook. Academic press; 2001.
7.	Oksanen J, Blanchet FG, Kindt R, Legendre P, Minchin PR, O’hara R, Simpson GL, Solymos P, Stevens MHH, Wagner H: Package ‘vegan’. Community ecology package, version 2013, 2.
8.	Upadhyay AA, Kauffman RC, Wolabaugh AN, Cho A, Patel NB, Reiss SM, Havenar-Daughton C, Dawoud RA, Tharp GK, Sanz I, et al: BALDR: a computational pipeline for paired heavy and light chain immunoglobulin reconstruction in single-cell RNA-seq data. Genome Med 2018, 10:20.
9.	Tange O: Gnu parallel-the command-line power tool. The USENIX Magazine 2011, 36:42-47.
10.	Bolger AM, Lohse M, Usadel B: Trimmomatic: a flexible trimmer for Illumina sequence data. Bioinformatics 2014, 30:2114-2120.
11.	Grabherr MG, Haas BJ, Yassour M, Levin JZ, Thompson DA, Amit I, Adiconis X, Fan L, Raychowdhury R, Zeng Q: Trinity: reconstructing a full-length transcriptome without a genome from RNA-Seq data. Nature biotechnology 2011, 29:644.
12.	Langmead B, Salzberg SL: Fast gapped-read alignment with Bowtie 2. Nat Methods 2012, 9:357-359.




