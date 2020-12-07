#!/bin/bash
# 10X scRNAseq Pipeline for V(D)J Analysis
# David Coffey dcoffey@fredhutch.org
# Updated October 26, 2020

# Define universal variables
export ROOT="/fh/fast/warren_h/users/dcoffey/scRNAseq/10X102020"
export FASTQ_DIRECTORY="/shared/ngs/illumina/dcoffey/201016_A00613_0187_AHVLG3DMXX/cellranger/mkfastq/HVLG3DMXX/outs/fastq_path"
export SAMPLESHEET="$ROOT/SampleSheet/HVLG3DMXX_102020.csv"
export VDJ_REFERENCE="/shared/silo_researcher/Warren_E/ngs/ReferenceGenomes/Human_genomes/refdata-cellranger-vdj-GRCh38-alts-ensembl-4.0.0"
export VDJ_SAMPLES="203428_4P_0_BCR 203428_4P_0_TCR 219747_25P_0_BCR 219747_25P_0_TCR 240343_30P_0_BCR 240343_30P_0_TCR 255945_43P_0_BCR 255945_43P_0_TCR 273442_4P_1_BCR 273442_4P_1_TCR 276148_52P_0_BCR 276148_52P_0_TCR 289023_56P_0_BCR 289023_56P_0_TCR 289894_58P_0_BCR 289894_58P_0_TCR 295198_25P_1_BCR 295198_25P_1_TCR 298771_66P_0_BCR 298771_66P_0_TCR 299361_67P_0_BCR 299361_67P_0_TCR 301077_64P_0_BCR 301077_64P_0_TCR 308146_73P_0_BCR 308146_73P_0_TCR 332751_30P_1_BCR 332751_30P_1_TCR 334277_43P_1_BCR 334277_43P_1_TCR 334330_88P_0_BCR 334330_88P_0_TCR 338291_52P_1_BCR 338291_52P_1_TCR 369521_56P_1_BCR 369521_56P_1_TCR 374868_66P_1_BCR 374868_66P_1_TCR 378886_73P_1_BCR 378886_73P_1_TCR 381401_64P_1_BCR 381401_64P_1_TCR 385922_58P_1_BCR 385922_58P_1_TCR 388178_88P_1_BCR 388178_88P_1_TCR 390589_67P_1_BCR 390589_67P_1_TCR"

# Make directories
mkdir -p $ROOT/VDJ
mkdir -p $ROOT/Links/Vloupe
mkdir -p $ROOT/Links/All_contig_annotations
mkdir -p $ROOT/Links/Clonotypes
mkdir -p $ROOT/Links/Consensus_annotations
mkdir -p $ROOT/Links/Filtered_contig_annotations
mkdir -p $ROOT/Links/Web_summary
mkdir -p $ROOT/Links/Metrics_summary

# Generate single-cell V(D)J sequences
for S in ${VDJ_SAMPLES}; do
    echo ${S}
    export SAMPLE=${S}
    sbatch -n 1 -t 1-0 -c 6 --mem 128G --job-name="VDJ" --output=$ROOT/Logs/VDJ.${S}.log $ROOT/Scripts/VDJ.sh
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