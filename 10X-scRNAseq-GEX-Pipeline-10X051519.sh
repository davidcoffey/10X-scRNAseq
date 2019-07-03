#!/bin/bash
# 10X scRNAseq Pipeline for Gene Expression (GEX) Analysis
# David Coffey dcoffey@fredhutch.org
# Updated July 2, 2019

# Define universal variables
export ROOT="/fh/fast/warren_h/users/dcoffey/scRNAseq/10X051519"
export SCRATCH="/fh/scratch/delete30/warren_h/dcoffey/scRNAseq/10X051519"
export BCL_DIRECTORY="/fh/fast/warren_h/SR/ngs/illumina/dcoffey/190531_A00613_0034_BHCJTVDRXX"
export FASTQ_DIRECTORY="$ROOT/Fastq/GEX"
export SAMPLESHEET="$ROOT/SampleSheet/HCJTVDRXX_051519.csv"
export SAMPLESHEET_H5="$ROOT/SampleSheet/HCJTVDRXX_H5_samples.csv"
export GEX_SAMPLES="203463_5P_1 213263_5P_1 204957_7P_0 257400_7P_1 211146_18P_0 252254_18P_1 216563_22P_0 256339_22P_1"
export GEX_REFERENCE="/shared/silo_researcher/Warren_E/ngs/ReferenceGenomes/Human_genomes/refdata-cellranger-hg19-3.0.0"
export MATRIX="$ROOT/Aggregate_unnormalized/outs/filtered_feature_bc_matrix/Filtered_expression_matrix.csv"
export MAGIC="$ROOT/MAGIC"

# Make directories
mkdir -p $ROOT/Logs
mkdir -p $SCRATCH
mkdir -p $ROOT/Counts
mkdir -p $ROOT/MAGIC
mkdir -p $ROOT/Matrices
mkdir -p $ROOT/Projections
mkdir -p $ROOT/Seurat
mkdir -p $ROOT/Links/Cloupe
mkdir -p $ROOT/Links/Web_summary
mkdir -p $ROOT/Links/Metrics_summary
mkdir -p $ROOT/Links/Combined

# Convert 5' GEX BCL files to FASTQ files
mkdir -p $FASTQ_DIRECTORY
sbatch -n 1 -c 4 -t 1-0 --job-name="MKFASTQ" --output=$ROOT/Logs/MakeFastQ-GE.log $ROOT/Scripts/MakeFastQ.sh
MKFASTQ=$(squeue -o "%A" -h -u dcoffey -n "MKFASTQ" -S i | tr "\n" ":")

# Generate single cell gene counts
for S in ${GEX_SAMPLES}; do
    echo ${S}
    export SAMPLE=${S}
    sbatch -n 1 -c 4 -t 3-0 --job-name="COUNTS" --dependency=afterany:${MKFASTQ%?} --output=$ROOT/Logs/Counts.${S}.log $ROOT/Scripts/Counts.sh
done

COUNTS=$(squeue -o "%A" -h -u dcoffey -n "COUNTS" -S i | tr "\n" ":")

# Aggregate samples to one gene counts matrix
sbatch -n 1 -c 4 -t 1-0 --job-name="AGGREGATE" --dependency=afterany:${COUNTS%?} --output=$ROOT/Logs/Aggregate.log $ROOT/Scripts/Aggregate.sh

AGGREGATE=$(squeue -o "%A" -h -u dcoffey -n "AGGREGATE" -S i | tr "\n" ":")

# Secondary data filtering using MAGIC in R
sbatch -n 1 -c 4 -t 1-0 --job-name="MAGIC" --dependency=afterany:${COUNTS%?} --wrap="Rscript $ROOT/Scripts/MAGIC.R" --output=$ROOT/Logs/MAGIC.log

# Create symbolic link for GEX files
for S in ${GEX_SAMPLES}; do
  find $ROOT/Counts/${S}/outs -name "web_summary.html" -type f -exec ln -s {} $ROOT/Links/Web_summary/${S}.web_summary.html ';'
  find $ROOT/Counts/${S}/outs -name "cloupe.cloupe" -type f -exec ln -s {} $ROOT/Links/Cloupe/${S}.cloupe ';'
  find $ROOT/Counts/${S}/outs -name "metrics_summary.csv" -type f -exec ln -s {} $ROOT/Links/Metrics_summary/${S}.metrics_summary.csv ';'
done

find $ROOT/Counts/Aggregate/Aggregate_normalized/outs -name "metrics_summary.csv" -type f -exec ln -s {} $ROOT/Links/Metrics_summary/Aggregate_normalized.metrics_summary.csv ';'
find $ROOT/Counts/Aggregate/Aggregate_unnormalized/outs -name "metrics_summary.csv" -type f -exec ln -s {} $ROOT/Links/Metrics_summary/Aggregate_unnormalized.metrics_summary.csv ';'
find $ROOT/Counts/Aggregate/Aggregate_normalized/outs -name "web_summary.html" -type f -exec ln -s {} $ROOT/Links/Web_summary/Aggregate_normalized.web_summary.html ';'
find $ROOT/Counts/Aggregate/Aggregate_unnormalized/outs -name "web_summary.html" -type f -exec ln -s {} $ROOT/Links/Web_summary/Aggregate_unnormalized.web_summary.html ';'
find $ROOT/Counts/Aggregate/Aggregate_normalized/outs -name "cloupe.cloupe" -type f -exec ln -s {} $ROOT/Links/Cloupe/Aggregate_normalized.cloupe ';'
find $ROOT/Counts/Aggregate/Aggregate_unnormalized/outs -name "cloupe.cloupe" -type f -exec ln -s {} $ROOT/Links/Cloupe/Aggregate_unnormalized.cloupe ';'

