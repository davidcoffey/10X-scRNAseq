#!/bin/bash
# Generate single-cell V(D)J sequences
# David Coffey dcoffey@fredhutch.org
# Updated October 26, 2020

# Varaibles
#export SAMPLE=""
#export FASTQ_DIRECTORY=""
#export VDJ_REFERENCE=""

# Start time
START=`date +%s`
echo Ran VDJ.sh on `date +"%B %d, %Y at %r"`

module load CellRanger/4.0.0
cd $ROOT/VDJ
cellranger vdj \
--id=$SAMPLE \
--reference=$VDJ_REFERENCE \
--fastqs=$FASTQ_DIRECTORY \
--sample=$SAMPLE

# End time
END=`date +%s`
MINUTES=$(((END-START)/60))
echo The run time was $MINUTES minutes.