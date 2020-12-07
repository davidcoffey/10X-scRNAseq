#!/bin/bash
# 10X scRNAseq Pipeline for Gene Expression (GEX) Analysis
# David Coffey dcoffey@fredhutch.org
# Updated October 26, 2020

# Define universal variables
export ROOT="/fh/fast/warren_h/users/dcoffey/scRNAseq/10X051519"
export BCL_DIRECTORY="/fh/fast/warren_h/SR/ngs/illumina/dcoffey/190531_A00613_0034_BHCJTVDRXX"
export FASTQ_DIRECTORY="$ROOT/Fastq/GEX"
export SAMPLESHEET="$ROOT/SampleSheet/HCJTVDRXX_051519.csv"
export SAMPLESHEET_H5="$ROOT/SampleSheet/HCJTVDRXX_H5_samples.csv"
export GEX_SAMPLES="203463_5P_0 213263_5P_1 204957_7P_0 257400_7P_1 211146_18P_0 252254_18P_1 216563_22P_0 256339_22P_1"
export GEX_REFERENCE="/shared/silo_researcher/Warren_E/ngs/ReferenceGenomes/Human_genomes/refdata-gex-GRCh38-2020-A"
export MATRIX="$ROOT/Aggregate_unnormalized/outs/filtered_feature_bc_matrix/Filtered_expression_matrix.csv"

# Make directories
mkdir -p $ROOT/Logs
mkdir -p $ROOT/Counts
mkdir -p $ROOT/Links/Cloupe
mkdir -p $ROOT/Links/Web_summary
mkdir -p $ROOT/Links/Metrics_summary
mkdir -p $ROOT/Links/Combined
mkdir -p $ROOT/Links/Expression_matrix

# Convert 5' GEX BCL files to FASTQ files
mkdir -p $FASTQ_DIRECTORY
sbatch -n 1 -t 1-0 -c 6 --mem 128G --job-name="MKFASTQ" --output=$ROOT/Logs/MakeFastQ-GE.log $ROOT/Scripts/MakeFastQ.sh
MKFASTQ=$(squeue -o "%A" -h -u dcoffey -n "MKFASTQ" -S i | tr "\n" ":")

# Generate single cell gene counts
for S in ${GEX_SAMPLES}; do
    echo ${S}
    export SAMPLE=${S}
    sbatch -n 1 -t 1-0 -c 6 --mem 128G --job-name="COUNTS" --dependency=afterany:${MKFASTQ%?} --output=$ROOT/Logs/Counts.${S}.log $ROOT/Scripts/Counts.sh
done

COUNTS=$(squeue -o "%A" -h -u dcoffey -n "COUNTS" -S i | tr "\n" ":")

# Aggregate samples to one gene counts matrix
sbatch -n 1 -t 1-0 -c 6 --mem 128G --job-name="AGGREGATE" --dependency=afterany:${COUNTS%?} --output=$ROOT/Logs/Aggregate.log $ROOT/Scripts/Aggregate.sh

AGGREGATE=$(squeue -o "%A" -h -u dcoffey -n "AGGREGATE" -S i | tr "\n" ":")

# Combine gene expression metrics
ml R/4.0.2-foss-2019b
sbatch -n 1 -c 4 -t 1-0 --job-name="COMBINE" --dependency=afterany:${AGGREGATE%?} --wrap="Rscript $ROOT/Scripts/CombineGEXmetrics.R" --output=$ROOT/Logs/CombineGEXmetrics.log

# Create symbolic link for GEX files
for S in ${GEX_SAMPLES}; do
  find $ROOT/Counts/${S}/outs -name "web_summary.html" -type f -exec ln -s {} $ROOT/Links/Web_summary/${S}.web_summary.html ';'
  find $ROOT/Counts/${S}/outs -name "cloupe.cloupe" -type f -exec ln -s {} $ROOT/Links/Cloupe/${S}.cloupe ';'
  find $ROOT/Counts/${S}/outs -name "metrics_summary.csv" -type f -exec ln -s {} $ROOT/Links/Metrics_summary/${S}.metrics_summary.csv ';'
  find $ROOT/Counts/${S}/outs -name "raw_feature_bc_matrix.h5" -type f -exec ln -s {} $ROOT/Links/Expression_matrix/${S}.raw_feature_bc_matrix.h5 ';'
done

find $ROOT/Counts/Aggregate_normalized/outs -name "metrics_summary.csv" -type f -exec ln -s {} $ROOT/Links/Metrics_summary/Aggregate_normalized.metrics_summary.csv ';'
find $ROOT/Counts/Aggregate_unnormalized/outs -name "metrics_summary.csv" -type f -exec ln -s {} $ROOT/Links/Metrics_summary/Aggregate_unnormalized.metrics_summary.csv ';'
find $ROOT/Counts/Aggregate_normalized/outs -name "web_summary.html" -type f -exec ln -s {} $ROOT/Links/Web_summary/Aggregate_normalized.web_summary.html ';'
find $ROOT/Counts/Aggregate_unnormalized/outs -name "web_summary.html" -type f -exec ln -s {} $ROOT/Links/Web_summary/Aggregate_unnormalized.web_summary.html ';'
find $ROOT/Counts/Aggregate_normalized/outs -name "cloupe.cloupe" -type f -exec ln -s {} $ROOT/Links/Cloupe/Aggregate_normalized.cloupe ';'
find $ROOT/Counts/Aggregate_unnormalized/outs -name "cloupe.cloupe" -type f -exec ln -s {} $ROOT/Links/Cloupe/Aggregate_unnormalized.cloupe ';'
find $ROOT/Counts/Aggregate_unnormalized/outs -name "raw_feature_bc_matrix.h5" -type f -exec ln -s {} $ROOT/Links/Expression_matrix/Aggregate_unnormalized.raw_feature_bc_matrix.h5 ';'
find $ROOT/Counts/Aggregate_normalized/outs -name "raw_feature_bc_matrix.h5" -type f -exec ln -s {} $ROOT/Links/Expression_matrix/Aggregate_normalized.raw_feature_bc_matrix.h5 ';'

