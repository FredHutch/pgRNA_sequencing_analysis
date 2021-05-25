# pgRNA_sequencing_analysis
Pipeline and custom scripts for analyzing paired gRNA (pgRNA) sequencing data for pgPEN screen.

*Link to Addgene and GEO*

*Include pgRNA annotations file? Or just link to paper/supp table*

## Sequencing information
*Link to picture of sequencing strategy*

## Sequencing analysis pipeline overview
1. Base calling
2. QC
3. Trimming reads: used FASTX-Toolkit v0.0.14 with parameters `-f 1 -l20` for read R1 (gRNA 1), `-f 2 -l 21` for read I1 (gRNA 2), and `-f 1 -l 6` for read I2 (index read)
4. Demultiplexing samples: used idemp *insert link* with parameters `-n 1` to allow for one mismatch in the sample barcode
5. Aligning reads: used Bowtie v1.2.2 with parameters `-q -v 1 --best --strata --all --sam -p 4` to align to reference pgRNA library
6. Convert SAM to BAM, sort: used SAMtools v1.9 to first convert from SAM to BAM format with parameters `-bS` and then to sort the output BAM file
7. Count pgRNAs: used custom script counter_efficient.R (see below for more details)
8. Calculate log fold change (LFC) for each pgRNA: used MAGeCK v0.5.9.2 `test` command with parameters `--day0-label` set to the plasmid counts column label and `--gene-lfc-method mean`

## Running counter_efficient.R
*check on updating version of R*
*Add versions of R and packages*

Arguments must be given in the following order:
1. annotation file containing the ID and sequence for each pgRNA in the pgPEN library
2. BAM file for gRNA 1 (BAM for gRNA 2 will be read in by substituting 2 for 1 in the file name)
3. number of chunks to split the BAM files into (we used 50)
4. counts file to store output matrix of pgRNA counts

We ran this script as a bash array job to obtain the counts for each sample independently. See script **run_counter_efficient_array.sh** as an example.
