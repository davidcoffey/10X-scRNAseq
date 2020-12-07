#!/bin/bash
# 10X scRNAseq Pipeline for Gene Expression (GEX) Analysis
# David Coffey dcoffey@fredhutch.org
# Updated October 26, 2020

# Define universal variables
export ROOT="/fh/fast/warren_h/users/dcoffey/scRNAseq/10XMMRFINE"
export SAMPLESHEET_H5="$ROOT/SampleSheet/MMRFINE_H5.csv"
export MATRIX="$ROOT/Aggregate_unnormalized/outs/filtered_feature_bc_matrix/Filtered_expression_matrix.csv"

# Make directories
mkdir -p $ROOT/Logs
mkdir -p $ROOT/Counts
mkdir -p $ROOT/Links/Fastq
mkdir -p $ROOT/Links/Cloupe
mkdir -p $ROOT/Links/Vloupe
mkdir -p $ROOT/Links/Web_summary
mkdir -p $ROOT/Links/Metrics_summary
mkdir -p $ROOT/Links/Combined
mkdir -p $ROOT/Links/Expression_matrix
mkdir -p $ROOT/Links/All_contig_annotations
mkdir -p $ROOT/Links/Clonotypes
mkdir -p $ROOT/Links/Consensus_annotations
mkdir -p $ROOT/Links/Filtered_contig_annotations
mkdir -p $ROOT/Links/BAM
mkdir -p $ROOT/Links/Filtered_feature_bc_matrix
mkdir -p $ROOT/Links/Airr_rearrangements

# Create symbolic link for Fastq files
export FASTQ_DIRECTORIES="/fh/fast/warren_h/users/dcoffey/scRNAseq/10X072419/Fastq/VDJ/HKJHCDMXX/ /fh/fast/warren_h/users/dcoffey/scRNAseq/10X041619/Fastq/VDJ/H7FF2DRXX/"
for F in ${FASTQ_DIRECTORIES}; do
  find ${F} -name "*.fastq.gz" -type f -exec ln -s {} $ROOT/Links/Fastq/VDJ ';'
done

export FASTQ_DIRECTORIES="/fh/fast/warren_h/users/dcoffey/scRNAseq/10X041619/Fastq/GEX/H7273DRXX/ /fh/fast/warren_h/users/dcoffey/scRNAseq/10X062719/Fastq/GEX/HK72HDMXX/ /fh/fast/warren_h/users/dcoffey/scRNAseq/10X051519/Fastq/GEX/HCJTVDRXX/"
for F in ${FASTQ_DIRECTORIES}; do
  find ${F} -name "*.fastq.gz" -type f -exec ln -s {} $ROOT/Links/Fastq/GEX ';'
done
  
find /shared/ngs/illumina/dcoffey/201016_A00613_0187_AHVLG3DMXX/cellranger/mkfastq/HVLG3DMXX/outs/fastq_path/HVLG3DMXX -name "*GEX*" -type f -exec ln -s {} $ROOT/Links/Fastq/GEX ';'
find /shared/ngs/illumina/dcoffey/201016_A00613_0187_AHVLG3DMXX/cellranger/mkfastq/HVLG3DMXX/outs/fastq_path/HVLG3DMXX -name "*TCR*" -type f -exec ln -s {} $ROOT/Links/Fastq/VDJ ';'
find /shared/ngs/illumina/dcoffey/201016_A00613_0187_AHVLG3DMXX/cellranger/mkfastq/HVLG3DMXX/outs/fastq_path/HVLG3DMXX -name "*BCR*" -type f -exec ln -s {} $ROOT/Links/Fastq/VDJ ';'


# Aggregate samples to one gene counts matrix
sbatch -n 1 -t 1-0 -c 6 --mem 128G --job-name="AGGREGATE" --output=$ROOT/Logs/Aggregate.log $ROOT/Scripts/Aggregate.sh

AGGREGATE=$(squeue -o "%A" -h -u dcoffey -n "AGGREGATE" -S i | tr "\n" ":")

# Create symbolic link for GEX files
export GEX_SAMPLES="201687_6B_0 202823_6P_0 333196_6B_1 333224_6P_1 203463_5P_0 213263_5P_1 204957_7P_0 257400_7P_1 211146_18P_0 252254_18P_1 216563_22P_0 256339_22P_1 229311_28P_0 239971_39P_0 242967_37P_0 258022_44P_0 293138_60P_0 298865_28P_1 301920_37P_1 302197_72P_0 311502_77P_0 317634_79P_0 325592_60P_1 341576_79P_1 354841_44P_1 376714_72P_1 383328_39P_1 383693_77P_1 203428_4P_0_GEX 219747_25P_0_GEX 240343_30P_0_GEX 255945_43P_0_GEX 273442_4P_1_GEX 276148_52P_0_GEX 289023_56P_0_GEX 289894_58P_0_GEX 295198_25P_1_GEX 298771_66P_0_GEX 299361_67P_0_GEX 301077_64P_0_GEX 308146_73P_0_GEX 332751_30P_1_GEX 334277_43P_1_GEX 334330_88P_0_GEX 338291_52P_1_GEX 369521_56P_1_GEX 374868_66P_1_GEX 378886_73P_1_GEX 381401_64P_1_GEX 385922_58P_1_GEX 388178_88P_1_GEX 390589_67P_1_GEX"
export RUNS="/fh/fast/warren_h/users/dcoffey/scRNAseq/10X041619 /fh/fast/warren_h/users/dcoffey/scRNAseq/10X051519 /fh/fast/warren_h/users/dcoffey/scRNAseq/10X062719 /fh/fast/warren_h/users/dcoffey/scRNAseq/10X102020"
for S in ${GEX_SAMPLES}; do
  for R in ${RUNS}; do
     find ${R}/Counts/${S}/outs -name "web_summary.html" -type f -exec ln -s {} $ROOT/Links/Web_summary/${S}.web_summary.html ';'
     find ${R}/Counts/${S}/outs -name "cloupe.cloupe" -type f -exec ln -s {} $ROOT/Links/Cloupe/${S}.cloupe ';'
     find ${R}/Counts/${S}/outs -name "metrics_summary.csv" -type f -exec ln -s {} $ROOT/Links/Metrics_summary/${S}.metrics_summary.csv ';'
     find ${R}/Counts/${S}/outs -name "raw_feature_bc_matrix.h5" -type f -exec ln -s {} $ROOT/Links/Expression_matrix/${S}.raw_feature_bc_matrix.h5 ';'
     find ${R}/Counts/${S}/outs -name "*.bam" -type f -exec ln -s {} $ROOT/Links/BAM/${S}.bam ';'
     find ${R}/Counts/${S}/outs -name "*.bai" -type f -exec ln -s {} $ROOT/Links/BAM/${S}.bai ';'
     find ${R}/Counts/${S}/outs/filtered_feature_bc_matrix/ -name "barcodes.tsv.gz" -type f -exec ln -s {} $ROOT/Links/Filtered_feature_bc_matrix/${S}.barcodes.tsv.gz ';'
     find ${R}/Counts/${S}/outs/filtered_feature_bc_matrix/ -name "matrix.mtx.gz" -type f -exec ln -s {} $ROOT/Links/Filtered_feature_bc_matrix/${S}.matrix.mtx.gz ';'
     find ${R}/Counts/${S}/outs/filtered_feature_bc_matrix/ -name "features.tsv.gz" -type f -exec ln -s {} $ROOT/Links/Filtered_feature_bc_matrix/${S}.features.tsv.gz ';'
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

# Create symbolic link for VDJ files
export VDJ_SAMPLES="201687_6B_0_TCR 202823_6P_0_TCR 333196_6B_1_TCR 333224_6P_1_TCR 201687_6B_0_BCR 202823_6P_0_BCR 333196_6B_1_BCR 333224_6P_1_BCR 203463_5P_1_BCR 203463_5P_1_TCR 204957_7P_0_BCR 204957_7P_0_TCR 211146_18P_0_BCR 211146_18P_0_TCR 213263_5P_1_BCR 213263_5P_1_TCR 216563_22P_0_BCR 216563_22P_0_TCR 229311_28P_0_BCR 229311_28P_0_TCR 239971_39P_0_BCR 239971_39P_0_TCR 242967_37P_0_BCR 242967_37P_0_TCR 252254_18P_1_BCR 252254_18P_1_TCR 256339_22P_1_BCR 256339_22P_1_TCR 257400_7P_1_BCR 257400_7P_1_TCR 258022_44P_0_BCR 258022_44P_0_TCR 293138_60P_0_BCR 293138_60P_0_TCR 298865_28P_1_BCR 298865_28P_1_TCR 301920_37P_1_BCR 301920_37P_1_TCR 302197_72P_0_BCR 302197_72P_0_TCR 311502_77P_0_BCR 311502_77P_0_TCR 317634_79P_0_BCR 317634_79P_0_TCR 325592_60P_1_BCR 325592_60P_1_TCR 341576_79P_1_BCR 341576_79P_1_TCR 354841_44P_1_BCR 354841_44P_1_TCR 376714_72P_1_BCR 376714_72P_1_TCR 383328_39P_1_BCR 383328_39P_1_TCR 383693_77P_1_BCR 383693_77P_1_TCR 203428_4P_0_BCR 273442_4P_1_TCR 273442_4P_1_BCR 203428_4P_0_TCR 219747_25P_0_BCR 240343_30P_0_BCR 219747_25P_0_TCR 240343_30P_0_TCR 276148_52P_0_BCR 255945_43P_0_TCR 289894_58P_0_BCR 295198_25P_1_BCR 289023_56P_0_BCR 298771_66P_0_BCR 289023_56P_0_TCR 299361_67P_0_BCR 289894_58P_0_TCR 301077_64P_0_BCR 308146_73P_0_BCR 334330_88P_0_BCR 369521_56P_1_BCR 334277_43P_1_BCR 308146_73P_0_TCR 332751_30P_1_BCR 332751_30P_1_TCR 334277_43P_1_TCR 374868_66P_1_BCR 298771_66P_0_TCR 338291_52P_1_TCR 378886_73P_1_BCR 369521_56P_1_TCR 299361_67P_0_TCR 338291_52P_1_BCR 378886_73P_1_TCR 381401_64P_1_BCR 390589_67P_1_BCR 385922_58P_1_BCR 388178_88P_1_BCR 390589_67P_1_TCR 374868_66P_1_TCR 388178_88P_1_TCR 385922_58P_1_TCR 276148_52P_0_TCR 295198_25P_1_TCR 334330_88P_0_TCR 301077_64P_0_TCR 381401_64P_1_TCR 255945_43P_0_BCR "
export RUNS="/fh/fast/warren_h/users/dcoffey/scRNAseq/10X072419 /fh/fast/warren_h/users/dcoffey/scRNAseq/10X041619 /fh/fast/warren_h/users/dcoffey/scRNAseq/10X102020"
for S in ${VDJ_SAMPLES}; do
    for R in ${RUNS}; do
      find ${R}/VDJ/${S}/outs -name "vloupe.vloupe" -type f -exec ln -s {} $ROOT/Links/Vloupe/${S}.vloupe ';'
      find ${R}/VDJ/${S}/outs -name "web_summary.html" -type f -exec ln -s {} $ROOT/Links/Web_summary/${S}.web_summary.html ';'
      find ${R}/VDJ/${S}/outs -name "all_contig_annotations.csv" -type f -exec ln -s {} $ROOT/Links/All_contig_annotations/${S}.all_contig_annotations.csv ';'
      find ${R}/VDJ/${S}/outs -name "clonotypes.csv" -type f -exec ln -s {} $ROOT/Links/Clonotypes/${S}.clonotypes.csv ';'
      find ${R}/VDJ/${S}/outs -name "consensus_annotations.csv" -type f -exec ln -s {} $ROOT/Links/Consensus_annotations/${S}.consensus_annotations.csv ';'
      find ${R}/VDJ/${S}/outs -name "filtered_contig_annotations.csv" -type f -exec ln -s {} $ROOT/Links/Filtered_contig_annotations/${S}.filtered_contig_annotations.csv ';'
      find ${R}/VDJ/${S}/outs -name "metrics_summary.csv" -type f -exec ln -s {} $ROOT/Links/Metrics_summary/${S}.metrics_summary.csv ';'
      find ${R}/VDJ/${S}/outs -name "airr_rearrangement.tsv" -type f -exec ln -s {} $ROOT/Links/Airr_rearrangements/${S}.airr_rearrangement.tsv ';'
  done
done

# Combine gene expression metrics
ml R/4.0.2-foss-2019b
sbatch -n 1 -c 4 -t 1-0 --job-name="COMBINE" --wrap="Rscript $ROOT/Scripts/CombineGEXmetrics.R" --output=$ROOT/Logs/GEX_metrics.log

# Combine gene expression metrics
ml R/4.0.2-foss-2019b
sbatch -n 1 -c 4 -t 1-0 --job-name="COMBINE" --wrap="Rscript $ROOT/Scripts/CombineVDJmetrics.R" --output=$ROOT/Logs/VDJ_metrics.log

# Repeat aggregation on sample subset.  In this analysis bone marrow samples will be excluded and sample 302197_72P_0 will be removed due to low UMI/cells and bone marrow samples
export SAMPLESHEET_H5="$ROOT/SampleSheet/MMRFINE_H5_subset.csv"

# Make directories
mkdir -p $ROOT/Counts/Subset

# Aggregate samples to one gene counts matrix
sbatch -n 2 -c 4 -t 1-0 --mem=8096 --job-name="AGGREGATE" --output=$ROOT/Logs/AggregateSubset.log $ROOT/Scripts/AggregateSubset.sh

# Create symbolic link for GEX files
find $ROOT/Counts/Subset/Aggregate_normalized/outs -name "metrics_summary.csv" -type f -exec ln -s {} $ROOT/Links/Metrics_summary/Aggregate_normalized_subset.metrics_summary.csv ';'
find $ROOT/Counts/Subset/Aggregate_unnormalized/outs -name "metrics_summary.csv" -type f -exec ln -s {} $ROOT/Links/Metrics_summary/Aggregate_unnormalized_subset.metrics_summary.csv ';'
find $ROOT/Counts/Subset/Aggregate_normalized/outs -name "web_summary.html" -type f -exec ln -s {} $ROOT/Links/Web_summary/Aggregate_normalized_subset.web_summary.html ';'
find $ROOT/Counts/Subset/Aggregate_unnormalized/outs -name "web_summary.html" -type f -exec ln -s {} $ROOT/Links/Web_summary/Aggregate_unnormalized_subset.web_summary.html ';'
find $ROOT/Counts/Subset/Aggregate_normalized/outs -name "cloupe.cloupe" -type f -exec ln -s {} $ROOT/Links/Cloupe/Aggregate_normalized_subset.cloupe ';'
find $ROOT/Counts/Subset/Aggregate_unnormalized/outs -name "cloupe.cloupe" -type f -exec ln -s {} $ROOT/Links/Cloupe/Aggregate_unnormalized_subset.cloupe ';'
find $ROOT/Counts/Subset/Aggregate_unnormalized/outs -name "raw_feature_bc_matrix.h5" -type f -exec ln -s {} $ROOT/Links/Expression_matrix/Aggregate_unnormalized_subset.raw_feature_bc_matrix.h5 ';'
find $ROOT/Counts/Subset/Aggregate_normalized/outs -name "raw_feature_bc_matrix.h5" -type f -exec ln -s {} $ROOT/Links/Expression_matrix/Aggregate_normalized_subset.raw_feature_bc_matrix.h5 ';'

AGGREGATE=$(squeue -o "%A" -h -u dcoffey -n "AGGREGATE" -S i | tr "\n" ":")
