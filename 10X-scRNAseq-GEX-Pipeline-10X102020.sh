#!/bin/bash
# 10X scRNAseq Pipeline for Gene Expression (GEX) Analysis
# David Coffey dcoffey@fredhutch.org
# Updated October 26, 2020

# Define universal variables
export ROOT="/fh/fast/warren_h/users/dcoffey/scRNAseq/10X102020"
export FASTQ_DIRECTORY="/shared/ngs/illumina/dcoffey/201016_A00613_0187_AHVLG3DMXX/cellranger/mkfastq/HVLG3DMXX/outs/fastq_path"
export SAMPLESHEET="$ROOT/SampleSheet/HVLG3DMXX_102020.csv"
export SAMPLESHEET_H5="$ROOT/SampleSheet/HVLG3DMXX_H5_samples.csv"
export GEX_REFERENCE="/shared/silo_researcher/Warren_E/ngs/ReferenceGenomes/Human_genomes/refdata-gex-GRCh38-2020-A"
export GEX_SAMPLES="203428_4P_0_GEX 219747_25P_0_GEX 240343_30P_0_GEX 255945_43P_0_GEX 273442_4P_1_GEX 276148_52P_0_GEX 289023_56P_0_GEX 289894_58P_0_GEX 295198_25P_1_GEX 298771_66P_0_GEX 299361_67P_0_GEX 301077_64P_0_GEX 308146_73P_0_GEX 332751_30P_1_GEX 334277_43P_1_GEX 334330_88P_0_GEX 338291_52P_1_GEX 369521_56P_1_GEX 374868_66P_1_GEX 378886_73P_1_GEX 381401_64P_1_GEX 385922_58P_1_GEX 388178_88P_1_GEX 390589_67P_1_GEX"
export MATRIX="$ROOT/Aggregate_unnormalized/outs/filtered_feature_bc_matrix/Filtered_expression_matrix.csv"

# Make directories
mkdir -p $ROOT/Logs
mkdir -p $ROOT/Counts
mkdir -p $ROOT/Links/Cloupe
mkdir -p $ROOT/Links/Web_summary
mkdir -p $ROOT/Links/Metrics_summary
mkdir -p $ROOT/Links/Combined
mkdir -p $ROOT/Links/Expression_matrix

# Generate single cell gene counts
for S in ${GEX_SAMPLES}; do
    echo ${S}
    export SAMPLE=${S}
    sbatch -n 1 -t 1-0 -c 6 --mem 128G --job-name="COUNTS" --output=$ROOT/Logs/Counts.${S}.log $ROOT/Scripts/Counts.sh
done

COUNTS=$(squeue -o "%A" -h -u dcoffey -n "COUNTS" -S i | tr "\n" ":")

# Aggregate samples to one gene counts matrix
sbatch -n 1 -t 1-0 -c 6 --mem 128G --job-name="AGGREGATE" --dependency=afterany:${COUNTS%?} --output=$ROOT/Logs/Aggregate.log $ROOT/Scripts/Aggregate.sh

AGGREGATE=$(squeue -o "%A" -h -u dcoffey -n "AGGREGATE" -S i | tr "\n" ":")

# Combine gene expression metrics
ml R/4.0.2-foss-2019b
sbatch -n 1 -t 1-0 -c 4 --job-name="COMBINE" --dependency=afterany:${AGGREGATE%?} --wrap="Rscript $ROOT/Scripts/CombineGEXmetrics.R" --output=$ROOT/Logs/CombineGEXmetrics.log

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
