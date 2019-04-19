#!/bin/bash
# 10X scRNAseq Pipeline
# David Coffey dcoffey@fredhutch.org
# Updated April 19, 2018

# Variables
#export ROOT=""
#export BCL_DIRECTORY=""
#export FASTQ_DIRECTORY=""

# Convert BCL files to FASTQ files
sbatch -n 1 -c 4 -t 3-0 --job-name="BLC2FASTQ" --output=$ROOT/Logs/MakeFastQ.log $ROOT/Scripts/MakeFastQ.sh

BLC2FASTQ=$(squeue -o "%A" -h -u dcoffey -n "BLC2FASTQ" -S i | tr "\n" ":")