#!/bin/bash
# Convert BCL files to FASTQ
# David Coffey dcoffey@fredhutch.org
# Updated October 26, 2020

# Varaibles
# export BCL_DIRECTORY=""
# export FASTQ_DIRECTORY=""
# export SAMPLESHEET=""

# Start time
START=`date +%s`
echo Ran MakeFastQ.sh on `date +"%B %d, %Y at %r"`

cd $FASTQ_DIRECTORY
module load CellRanger/4.0.0
cellranger mkfastq \
--run=$BCL_DIRECTORY \
--output-dir=$FASTQ_DIRECTORY \
--csv=$SAMPLESHEET

# End time
END=`date +%s`
MINUTES=$(((END-START)/60))
echo The run time was $MINUTES minutes.