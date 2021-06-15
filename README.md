# pgPEN_sequencing_analysis
Pipeline and custom scripts for analyzing paired gRNA (pgRNA) sequencing data for pgPEN screen.
* For manuscript describing the pgPEN approach and results from PC9 and HeLa paralog screens, see: https://doi.org/10.1101/2020.12.20.423710.
  * For more information about the pgPEN sequencing strategy, see Fig. S1C.
* GEO accession number to access raw and processed data from the PC9 and HeLa pgPEN screens: GSE178179.
* Addgene pooled pgPEN library number: 171172.


## Sequencing analysis pipeline overview
1. Image analysis and base calling were performed on board the Illumina HiSeq 2500 with RTA 1.18.66.3 software. Generation of FASTQ files was performed with Illumina's bcl2fastq v2.20 Conversion Software, including the following non-default parameters:  `--create-fastq-for-index-reads --with-failed-reads --minimum-trimmed-read-length 2 --mask-short-adapter-reads 2`.
2. Trimming reads: used FASTX-Toolkit v0.0.14 with parameters `-f 1 -l20` for read R1 (gRNA 1), `-f 2 -l 21` for read I1 (gRNA 2), and `-f 1 -l 6` for read I2 (sample index read).
3. Demultiplexing samples: used idemp (https://github.com/yhwu/idemp) with parameters `-n 1` to allow for one mismatch in the sample barcode.
4. Aligning reads: used Bowtie v1.2.2 with parameters `-q -v 1 --best --strata --all --sam -p 4` to align to reference pgRNA library.
5. Convert SAM to BAM, sort: used SAMtools v1.9 to first convert from SAM to BAM format with parameters `-bS` and then to sort the output BAM file.
6. Count pgRNAs: used custom script counter_efficient.R (see below for more details).
7. Calculate log fold change (LFC) for each pgRNA: used MAGeCK v0.5.9.2 `test` command with parameters `--day0-label` set to the plasmid counts column label and `--gene-lfc-method mean`.

## Running counter_efficient.R
We used R v3.6.2 with packages: Rsamtools v1.34.1 and tidyverse v1.2.1.

Arguments must be given in the following order:
1. annotation file containing the ID and sequence for each pgRNA in the pgPEN library (included in this folder as paralog_pgRNA_annotations.txt).
2. BAM file for gRNA 1 (BAM for gRNA 2 will be read in by substituting 2 for 1 in the file name); filename must be in the format: cellLine.sampleN.gRNA_1.bam, where max(N) = number of samples.
3. number of chunks to split the BAM files into (we used 50)
4. counts file to store output matrix of pgRNA counts

We ran this script as a bash array job to obtain the counts for each sample independently. See script **run_counter_efficient_array.sh** as an example.
