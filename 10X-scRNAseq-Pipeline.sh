#!/bin/bash
# 10X scRNAseq Pipeline
# David Coffey dcoffey@fredhutch.org
# Updated May 4, 2019

# Define universal variables
export ROOT="/fh/fast/warren_h/users/dcoffey/scRNAseq/10X041619"
export SCRATCH="/fh/scratch/delete30/warren_h/dcoffey/scRNAseq/10X041619"
export SAMPLESHEET_H5="$ROOT/SampleSheet/AH7273DRXX_H5_samples.csv"
export GE_REFERENCE="/shared/silo_researcher/Warren_E/ngs/ReferenceGenomes/Human_genomes/refdata-cellranger-hg19-3.0.0"
export VDJ_REFERENCE="/shared/silo_researcher/Warren_E/ngs/ReferenceGenomes/Human_genomes/refdata-cellranger-vdj-GRCh38-alts-ensembl-2.0.0"
export GE_SAMPLES="201687_6B_0 202823_6P_0 333196_6B_1 333224_6P_1"
export VDJ_SAMPLES="201687_6B_0_TCR 202823_6P_0_TCR 333196_6B_1_TCR 333224_6P_1_TCR 201687_6B_0_BCR 202823_6P_0_BCR 333196_6B_1_BCR 333224_6P_1_BCR"
export MAGIC="$ROOT/MAGIC"

# Make directories
mkdir -p $ROOT/Logs
mkdir -p $SCRATCH
mkdir -p $ROOT/Counts
mkdir -p $ROOT/VDJ
mkdir -p $ROOT/MAGIC

############# GE Pipeline #############

# Convert 5' GE BCL files to FASTQ files
export BCL_DIRECTORY="/fh/fast/warren_h/SR/ngs/illumina/dcoffey/190416_A00613_0023_AH7273DRXX"
export FASTQ_DIRECTORY="$ROOT/FASTQ/GE"
export SAMPLESHEET="$ROOT/SampleSheet/AH7273DRXX_041619.csv"
mkdir -p $FASTQ_DIRECTORY
sbatch -n 1 -c 4 -t 1-0 --job-name="GEBLC2FASTQ" --output=$ROOT/Logs/MakeFastQ-GE.log $ROOT/Scripts/MakeFastQ.sh

GEBLC2FASTQ=$(squeue -o "%A" -h -u dcoffey -n "GEBLC2FASTQ" -S i | tr "\n" ":")

# Generate single cell gene counts
export FASTQ_DIRECTORY="$ROOT/FASTQ/GE"
for S in ${GE_SAMPLES}; do
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

############# VDJ Pipeline #############

# Convert V(D)J BCL files to FASTQ files
export BCL_DIRECTORY="/fh/fast/warren_h/SR/ngs/illumina/dcoffey/190501_A00613_0028_AH7FF2DRXX/Raw"
export FASTQ_DIRECTORY="$ROOT/FASTQ/VDJ"
export SAMPLESHEET="$ROOT/SampleSheet/AH7FF2DRXX_050319.csv"
mkdir -p $FASTQ_DIRECTORY
sbatch -n 1 -c 4 -t 1-0 --job-name="VDJBLC2FASTQ" --output=$ROOT/Logs/MakeFastQ-VDJ.log $ROOT/Scripts/MakeFastQ.sh

VDJBLC2FASTQ=$(squeue -o "%A" -h -u dcoffey -n "VDJBLC2FASTQ" -S i | tr "\n" ":")

# Generate single-cell V(D)J sequences
export FASTQ_DIRECTORY="$ROOT/FASTQ/VDJ"
for S in ${VDJ_SAMPLES}; do
    echo ${S}
    export SAMPLE=${S}
    sbatch -n 1 -c 4 -t 3-0 --job-name="VDJ" --output=$ROOT/Logs/VDJ.${S}.log $ROOT/Scripts/VDJ.sh
done

VDJ=$(squeue -o "%A" -h -u dcoffey -n "VDJ" -S i | tr "\n" ":")


