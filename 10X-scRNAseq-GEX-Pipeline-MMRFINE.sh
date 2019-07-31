#!/bin/bash
# 10X scRNAseq Pipeline for Gene Expression (GEX) Analysis
# David Coffey dcoffey@fredhutch.org
# Updated July 5, 2019

# Define universal variables
export ROOT="/fh/fast/warren_h/users/dcoffey/scRNAseq/10XMMRFINE"
export SAMPLESHEET_H5="$ROOT/SampleSheet/MMRFINE_H5.csv"
export MATRIX="$ROOT/Aggregate_unnormalized/outs/filtered_feature_bc_matrix/Filtered_expression_matrix.csv"
export MAGIC="$ROOT/MAGIC"

# Make directories
mkdir -p $ROOT/Logs
mkdir -p $ROOT/Counts
mkdir -p $ROOT/MAGIC
mkdir -p $ROOT/Projections
mkdir -p $ROOT/Seurat
mkdir -p $ROOT/Links/Cloupe
mkdir -p $ROOT/Links/Web_summary
mkdir -p $ROOT/Links/Metrics_summary
mkdir -p $ROOT/Links/Combined
mkdir -p $ROOT/Links/Expression_matrix

# Aggregate samples to one gene counts matrix
sbatch -n 1 -c 4 -t 1-0 --job-name="AGGREGATE" --output=$ROOT/Logs/Aggregate.log $ROOT/Scripts/Aggregate.sh

AGGREGATE=$(squeue -o "%A" -h -u dcoffey -n "AGGREGATE" -S i | tr "\n" ":")

# Secondary data filtering using MAGIC in R
sbatch -n 1 -c 4 -t 1-0 --job-name="MAGIC" --dependency=afterany:${AGGREGATE%?} --wrap="Rscript $ROOT/Scripts/MAGIC.R" --output=$ROOT/Logs/MAGIC.log

# Combine gene expression metrics
sbatch -n 1 -c 4 -t 1-0 --job-name="COMBINE" --dependency=afterany:${AGGREGATE%?} --wrap="Rscript $ROOT/Scripts/CombineGEXmetrics.R" --output=$ROOT/Logs/MAGIC.log

# Create symbolic link for GEX files
export GEX_SAMPLES="201687_6B_0 202823_6P_0 333196_6B_1 333224_6P_1 203463_5P_0 213263_5P_1 204957_7P_0 257400_7P_1 211146_18P_0 252254_18P_1 216563_22P_0 256339_22P_1 229311_28P_0 239971_39P_0 242967_37P_0 258022_44P_0 293138_60P_0 298865_28P_1 301920_37P_1 302197_72P_0 311502_77P_0 317634_79P_0 325592_60P_1 341576_79P_1 354841_44P_1 376714_72P_1 383328_39P_1 383693_77P_1"
export RUNS="/fh/fast/warren_h/users/dcoffey/scRNAseq/10X041619 /fh/fast/warren_h/users/dcoffey/scRNAseq/10X051519 /fh/fast/warren_h/users/dcoffey/scRNAseq/10X062719"
for S in ${GEX_SAMPLES}; do
  for R in ${RUNS}; do
     find ${R}/Counts/${S}/outs -name "web_summary.html" -type f -exec ln -s {} $ROOT/Links/Web_summary/${S}.web_summary.html ';'
     find ${R}/Counts/${S}/outs -name "cloupe.cloupe" -type f -exec ln -s {} $ROOT/Links/Cloupe/${S}.cloupe ';'
     find ${R}/Counts/${S}/outs -name "metrics_summary.csv" -type f -exec ln -s {} $ROOT/Links/Metrics_summary/${S}.metrics_summary.csv ';'
     find ${R}/Counts/${S}/outs -name "raw_feature_bc_matrix.h5" -type f -exec ln -s {} $ROOT/Links/Expression_matrix/${S}.raw_feature_bc_matrix.h5 ';'
  done
done

find $ROOT/Counts/Aggregate_normalized/outs -name "metrics_summary.csv" -type f -exec ln -s {} $ROOT/Links/Metrics_summary/Aggregate_normalized.metrics_summary.csv ';'
find $ROOT/Counts/Aggregate_unnormalized/outs -name "metrics_summary.csv" -type f -exec ln -s {} $ROOT/Links/Metrics_summary/Aggregate_unnormalized.metrics_summary.csv ';'
find $ROOT/Counts/Aggregate_normalized/outs -name "web_summary.html" -type f -exec ln -s {} $ROOT/Links/Web_summary/Aggregate_normalized.web_summary.html ';'
find $ROOT/Counts/Aggregate_unnormalized/outs -name "web_summary.html" -type f -exec ln -s {} $ROOT/Links/Web_summary/Aggregate_unnormalized.web_summary.html ';'
find $ROOT/Counts/Aggregate_normalized/outs -name "cloupe.cloupe" -type f -exec ln -s {} $ROOT/Links/Cloupe/Aggregate_normalized.cloupe ';'
find $ROOT/Counts/Aggregate_unnormalized/outs -name "cloupe.cloupe" -type f -exec ln -s {} $ROOT/Links/Cloupe/Aggregate_unnormalized.cloupe ';'
find $ROOT/Counts/Aggregate_unnormalized/outs -name "raw_feature_bc_matrix.h5" -type f -exec ln -s {} $ROOT/Links/Expression_matrix/Aggregate_unnormalized.raw_feature_bc_matrix.h5 ';'
find $ROOT/Counts/Aggregate_normalized/outs -name "raw_feature_bc_matrix.h5" -type f -exec ln -s {} $ROOT/Links/Expression_matrix/Aggregate_normalized.raw_feature_bc_matrix.h5 ';'
