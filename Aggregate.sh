#!/bin/bash
# Aggregate samples to one gene counts matrix
# Yuexin Xu yxu2@fredhutch.org
# Updated April 22, 2019

# Varaibles
#export ROOT="/fh/fast/warren_h/users/dcoffey/scRNAseq/10X041619"
#export SAMPLESHEET_H5="$ROOT/SampleSheet/AH7273DRXX_H5_samples.csv"
#export SAMPLES="201687_6B_0 202823_6P_0 333196_6B_1 333224_6P_1"
#export FASTQ_DIRECTORY="$ROOT/FASTQ"

# Start time
START=`date +%s`
echo Ran Aggregate.sh on `date +"%B %d, %Y at %r"`

module load cellranger 
cd $ROOT
cellranger aggr \
--id=Aggregate \
--csv=$SAMPLESHEET_H5 

# End time
END=`date +%s`
MINUTES=$(((END-START)/60))
echo The run time was $MINUTES minutes.

