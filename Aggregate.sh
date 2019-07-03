#!/bin/bash
# Aggregate samples to one gene counts matrix
# Yuexin Xu yxu2@fredhutch.org
# Updated April 22, 2019

# Varaibles
#export ROOT="/fh/fast/warren_h/users/dcoffey/scRNAseq/10X041619"
#export SAMPLESHEET_H5="$ROOT/SampleSheet/AH7273DRXX_H5_samples.csv"

# Start time
START=`date +%s`
echo Ran Aggregate.sh on `date +"%B %d, %Y at %r"`

# Aggregate samples and normalize (subsample reads from higher-depth GEM wells until they all have an equal number of confidently mapped reads per cell)
module load cellranger 
cd $ROOT/Counts/Aggregate
cellranger aggr \
--id=Aggregate_normalized \
--csv=$SAMPLESHEET_H5 \
--normalize=mapped

# Convert gene expression matrix from sparse format MEX to dense format .csv
cellranger mat2csv $ROOT/Aggregate_normalized/outs/filtered_feature_bc_matrix $ROOT/Aggregate_normalized/outs/filtered_feature_bc_matrix/Filtered_expression_matrix.csv

# Aggregate samples and but do not normalize
cellranger aggr \
--id=Aggregate_unnormalized \
--csv=$SAMPLESHEET_H5 \
--normalize=none

# Convert gene expression matrix from sparse format MEX to dense format .csv
cellranger mat2csv $ROOT/Aggregate_unnormalized/outs/filtered_feature_bc_matrix $ROOT/Aggregate_unnormalized/outs/filtered_feature_bc_matrix/Filtered_expression_matrix.csv

# End time
END=`date +%s`
MINUTES=$(((END-START)/60))
echo The run time was $MINUTES minutes.

