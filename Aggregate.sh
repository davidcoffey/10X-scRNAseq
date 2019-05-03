#!/bin/bash
# Aggregate samples to one gene counts matrix
# Yuexin Xu yxu2@fredhutch.org
# Updated April 22, 2019

# Varaibles
#export ROOT="/fh/fast/warren_h/users/dcoffey/scRNAseq/10X041619"
#export SAMPLESHEET_H5="$ROOT/SampleSheet/AH7273DRXX_H5_samples.csv"
#export MATRIX_DIRECTORY="$ROOT/Aggregate/outs/filtered_feature_bc_matrix"

# Start time
START=`date +%s`
echo Ran Aggregate.sh on `date +"%B %d, %Y at %r"`

module load cellranger 
cd $ROOT
cellranger aggr \
--id=Aggregate \
--csv=$SAMPLESHEET_H5 \
--normalize=mapped

# convert gene expression matrix from sparse format MEX to dense format .csv
cellranger mat2csv $MATRIX_DIRECTORY $MATRIX_DIRECTORY/Filtered_expression_matrix.csv

# End time
END=`date +%s`
MINUTES=$(((END-START)/60))
echo The run time was $MINUTES minutes.

