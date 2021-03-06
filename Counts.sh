#!/bin/bash
# Generate single cell gene counts
# David Coffey dcoffey@fredhutch.org
# Updated October 26, 2020

# Varaibles
#export SAMPLE=""
#export FASTQ_DIRECTORY=""
#export GEX_REFERENCE=""

# Start time
START=`date +%s`
echo Ran Counts.sh on `date +"%B %d, %Y at %r"`

module load CellRanger/4.0.0
cd $ROOT/Counts
cellranger count \
--id=$SAMPLE \
--transcriptome=$GEX_REFERENCE \
--fastqs=$FASTQ_DIRECTORY \
--sample=$SAMPLE \
--expect-cells=10000 \
--chemistry=fiveprime

# End time
END=`date +%s`
MINUTES=$(((END-START)/60))
echo The run time was $MINUTES minutes.