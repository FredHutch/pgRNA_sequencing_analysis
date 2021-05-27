#!/bin/bash

## sbatch parameters
#SBATCH --job-name=HeLa_counter
#SBATCH --output=HeLa_counter_%A_%a.out
#SBATCH --array=1-5
#SBATCH --time=8:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=98G

## load appropriate R module with necessary packages
module load R/3.6.2-foss-2018b-fh1

## assign variables
script_dir="/home/pparrish/paralog_pgRNA_screen/scripts/pgRNA_sequencing_analysis/"
base_dir="/home/pparrish/bergerlab_shared/Projects/paralog_pgRNA/"
annot_file="${base_dir}annotations/paralog_pgRNA_annotations.txt"
gRNA1_bam="${base_dir}bowtie1_aligned/200722_HeLa_screen/bam_sorted/HeLa.sample${SLURM_ARRAY_TASK_ID}.gRNA_1.bam"
n_chunks=50
counts_file="${base_dir}pgRNA_counts/200722_HeLa_screen/counts_HeLa.sample${SLURM_ARRAY_TASK_ID}.txt"

## run script with args:
## (1) annotation file containing the ID and sequence for each pgRNA in the pgPEN library
## (2) BAM file for gRNA 1 (BAM for gRNA 2 will be read in by substituting 2 for 1 in the file name)
## (3) number of chunks to split the BAM files into (we used 50)
## (4) counts file to store output matrix of pgRNA counts
Rscript "${script_dir}counter_efficient.R" "${annot_file}" "${gRNA1_bam}" "${n_chunks}" "${counts_file}"
