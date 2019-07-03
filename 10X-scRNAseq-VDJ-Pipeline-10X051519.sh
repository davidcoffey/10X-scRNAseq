#!/bin/bash
# 10X scRNAseq Pipeline for V(D)J Analysis
# David Coffey dcoffey@fredhutch.org
# Updated July 2, 2019

# Define universal variables
export ROOT="/fh/fast/warren_h/users/dcoffey/scRNAseq/10X051519"
export SCRATCH="/fh/scratch/delete30/warren_h/dcoffey/scRNAseq/10X051519"
export BCL_DIRECTORY="/fh/fast/warren_h/SR/ngs/illumina/dcoffey/"
export FASTQ_DIRECTORY="$ROOT/Fastq/VDJ"
export VDJ_REFERENCE="/shared/silo_researcher/Warren_E/ngs/ReferenceGenomes/Human_genomes/refdata-cellranger-vdj-GRCh38-alts-ensembl-2.0.0"
export VDJ_SAMPLES=""

# Make directories
mkdir -p $ROOT/VDJ
mkdir -p $ROOT/Links/Vloupe
mkdir -p $ROOT/Links/All_contig_annotations
mkdir -p $ROOT/Links/Clonotypes
mkdir -p $ROOT/Links/Consensus_annotations
mkdir -p $ROOT/Links/Filtered_contig_annotations

# Convert V(D)J BCL files to FASTQ files
mkdir -p $FASTQ_DIRECTORY
sbatch -n 1 -c 4 -t 1-0 --job-name="MKFASTQ" --output=$ROOT/Logs/MakeFastQ-VDJ.log $ROOT/Scripts/MakeFastQ.sh

MKFASTQ=$(squeue -o "%A" -h -u dcoffey -n "MKFASTQ" -S i | tr "\n" ":")

# Generate single-cell V(D)J sequences
for S in ${VDJ_SAMPLES}; do
    echo ${S}
    export SAMPLE=${S}
    sbatch -n 1 -c 4 -t 3-0 --job-name="VDJ" --output=$ROOT/Logs/VDJ.${S}.log $ROOT/Scripts/VDJ.sh
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
