#!/bin/bash
# 10X scRNAseq Pipeline
# David Coffey dcoffey@fredhutch.org
# Updated April 19, 2018

# Variables
export ROOT="/fh/fast/warren_h/users/dcoffey/scRNAseq/10X041619"
export SCRATCH="/fh/scratch/delete30/warren_h/dcoffey/scRNAseq/10X041619"
export BCL_DIRECTORY="/fh/fast/warren_h/SR/ngs/illumina/dcoffey/190416_A00613_0023_AH7273DRXX"
export FASTQ_DIRECTORY="$ROOT/FASTQ"
export SAMPLESHEET="$ROOT/SampleSheet/AH7273DRXX_041619.csv"
export REFERENCE="/shared/silo_researcher/Warren_E/ngs/ReferenceGenomes/Human_genomes/refdata-cellranger-hg19-3.0.0"
export SAMPLES="201687_6B_0 202823_6P_0 333196_6B_1 333224_6P_1"
export SAMPLESHEET_H5="$ROOT/SampleSheet/AH7273DRXX_H5_samples.csv"
export MATRIX_DIRECTORY="$ROOT/Aggregate/outs/filtered_feature_bc_matrix"
export MATRIX="$MATRIX_DIRECTORY/Filtered_feature_bc_matrix.csv"
export MAGIC="$ROOT/MAGIC"

# Make directories
mkdir -p $ROOT/Logs
mkdir -p $FASTQ_DIRECTORY
mkdir -p $SCRATCH
mkdir -p $ROOT/Counts
mkdir -p $ROOT/MAGIC

# Convert BCL files to FASTQ files
sbatch -n 1 -c 4 -t 1-0 --job-name="BLC2FASTQ" --output=$ROOT/Logs/MakeFastQ.log $ROOT/Scripts/MakeFastQ.sh

BLC2FASTQ=$(squeue -o "%A" -h -u dcoffey -n "BLC2FASTQ" -S i | tr "\n" ":")

# Generate single cell gene counts
for S in ${SAMPLES}; do
    echo ${S}
    export SAMPLE=${S}
    sbatch -n 1 -c 4 -t 3-0 --job-name="COUNTS" --output=$ROOT/Logs/Counts.${S}.log $ROOT/Scripts/Counts.sh
done

COUNTS=$(squeue -o "%A" -h -u dcoffey -n "COUNTS" -S i | tr "\n" ":")

# Aggregate samples to one gene counts matrix
sbatch -n 1 -c 4 -t 1-0 --job-name="AGGREGATE" --output=$ROOT/Logs/Aggregate.log $ROOT/Scripts/Aggregate.sh

AGGREGATE=$(squeue -o "%A" -h -u dcoffey -n "AGGREGATE" -S i | tr "\n" ":")

# Secondary data filtering using MAGIC in R
sbatch -n 1 -c 4 -t 1-0 --job-name="MAGIC" --wrap="Rscript $ROOT/Scripts/MAGIC.R" --output=$ROOT/Logs/MAGIC.log

