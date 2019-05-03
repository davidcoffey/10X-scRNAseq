#!/bin/bash
# Generate single cell gene counts
# David Coffey dcoffey@fredhutch.org
# Updated April 20, 2018

# Varaibles
#export SAMPLE=""
#export FASTQ_DIRECTORY=""
#export REFERENCE=""

# Start time
START=`date +%s`
echo Ran Counts.sh on `date +"%B %d, %Y at %r"`

module load cellranger
cd $ROOT/Counts
cellranger count \
--id=$SAMPLE \
--transcriptome=$REFERENCE \
--fastqs=$FASTQ_DIRECTORY \
--sample=$SAMPLE \
--expect-cells=10000

# End time
END=`date +%s`
MINUTES=$(((END-START)/60))
echo The run time was $MINUTES minutes.