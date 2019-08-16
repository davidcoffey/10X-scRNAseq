#!/bin/bash
# 10X scRNAseq Pipeline for V(D)J Analysis
# David Coffey dcoffey@fredhutch.org
# Updated July 25, 2019

# Define universal variables
export ROOT="/fh/fast/warren_h/users/dcoffey/scRNAseq/10X072419"
export BCL_DIRECTORY="/fh/fast/warren_h/SR/ngs/illumina/dcoffey/190723_A00613_0044_BHKJHCDMXX"
export FASTQ_DIRECTORY="$ROOT/Fastq/VDJ"
export SAMPLESHEET="$ROOT/SampleSheet/HKJHCDMXX_072419.csv"
export VDJ_REFERENCE="/shared/silo_researcher/Warren_E/ngs/ReferenceGenomes/Human_genomes/refdata-cellranger-vdj-GRCh38-alts-ensembl-3.1.0"
export VDJ_SAMPLES="203463_5P_1_BCR 203463_5P_1_TCR 204957_7P_0_BCR 204957_7P_0_TCR 211146_18P_0_BCR 211146_18P_0_TCR 213263_5P_1_BCR 213263_5P_1_TCR 216563_22P_0_BCR 216563_22P_0_TCR 229311_28P_0_BCR 229311_28P_0_TCR 239971_39P_0_BCR 239971_39P_0_TCR 242967_37P_0_BCR 242967_37P_0_TCR 252254_18P_1_BCR 252254_18P_1_TCR 256339_22P_1_BCR 256339_22P_1_TCR 257400_7P_1_BCR 257400_7P_1_TCR 258022_44P_0_BCR 258022_44P_0_TCR 293138_60P_0_BCR 293138_60P_0_TCR 298865_28P_1_BCR 298865_28P_1_TCR 301920_37P_1_BCR 301920_37P_1_TCR 302197_72P_0_BCR 302197_72P_0_TCR 311502_77P_0_BCR 311502_77P_0_TCR 317634_79P_0_BCR 317634_79P_0_TCR 325592_60P_1_BCR 325592_60P_1_TCR 341576_79P_1_BCR 341576_79P_1_TCR 354841_44P_1_BCR 354841_44P_1_TCR 376714_72P_1_BCR 376714_72P_1_TCR 383328_39P_1_BCR 383328_39P_1_TCR 383693_77P_1_BCR 383693_77P_1_TCR"

# Make directories
mkdir -p $ROOT/VDJ
mkdir -p $ROOT/Links/Vloupe
mkdir -p $ROOT/Links/All_contig_annotations
mkdir -p $ROOT/Links/Clonotypes
mkdir -p $ROOT/Links/Consensus_annotations
mkdir -p $ROOT/Links/Filtered_contig_annotations
mkdir -p $ROOT/Links/Web_summary
mkdir -p $ROOT/Links/Metrics_summary

# Convert V(D)J BCL files to FASTQ files
mkdir -p $FASTQ_DIRECTORY
sbatch -n 1 -c 4 -t 1-0 --job-name="MKFASTQ" --output=$ROOT/Logs/MakeFastQ-VDJ.log $ROOT/Scripts/MakeFastQ.sh

MKFASTQ=$(squeue -o "%A" -h -u dcoffey -n "MKFASTQ" -S i | tr "\n" ":")

# Generate single-cell V(D)J sequences
for S in ${VDJ_SAMPLES}; do
    echo ${S}
    export SAMPLE=${S}
    sbatch -n 1 -c 4 -t 3-0 --job-name="VDJ" --dependency=afterany:${MKFASTQ%?} --output=$ROOT/Logs/VDJ.${S}.log $ROOT/Scripts/VDJ.sh
done

VDJ=$(squeue -o "%A" -h -u dcoffey -n "VDJ" -S i | tr "\n" ":")

# Create symbolic links for VDJ files
for S in ${VDJ_SAMPLES}; do
  find $ROOT/VDJ/${S}/outs -name "vloupe.vloupe" -type f -exec ln -s {} $ROOT/Links/Vloupe/${S}.vloupe ';'
  find $ROOT/VDJ/${S}/outs -name "web_summary.html" -type f -exec ln -s {} $ROOT/Links/Web_summary/${S}.web_summary.html ';'
  find $ROOT/VDJ/${S}/outs -name "all_contig_annotations.csv" -type f -exec ln -s {} $ROOT/Links/All_contig_annotations/${S}.all_contig_annotations.csv ';'
  find $ROOT/VDJ/${S}/outs -name "clonotypes.csv" -type f -exec ln -s {} $ROOT/Links/Clonotypes/${S}.clonotypes.csv ';'
  find $ROOT/VDJ/${S}/outs -name "consensus_annotations.csv" -type f -exec ln -s {} $ROOT/Links/Consensus_annotations/${S}.consensus_annotations.csv ';'
  find $ROOT/VDJ/${S}/outs -name "filtered_contig_annotations.csv" -type f -exec ln -s {} $ROOT/Links/Filtered_contig_annotations/${S}.filtered_contig_annotations.csv ';'
  find $ROOT/VDJ/${S}/outs -name "metrics_summary.csv" -type f -exec ln -s {} $ROOT/Links/Metrics_summary/${S}.metrics_summary.csv ';'
done