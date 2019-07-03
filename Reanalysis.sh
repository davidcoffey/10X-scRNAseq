#!/bin/bash
# Reanalysis of single-cell V(D)J GEX
# Yuexin Xu yxu2@fredhutch.org
# Updated May 28, 2019

# Varaibles
#export ROOT="/fh/fast/warren_h/users/dcoffey/scRNAseq/10X041619"

# Start time
START=`date +%s`
echo Ran VDJ.sh on `date +"%B %d, %Y at %r"`

module load cellranger
cd $ROOT
ls -1 $ROOT/Aggregate_normalized/outs/*.h5 # verify the input file exists
cellranger reanalyze --id=Aggregate_normalized_reanalysis_1000cells \
                       --matrix=$ROOT/Aggregate_normalized/outs/filtered_feature_bc_matrix.h5 \
                       --params=$ROOT/SampleSheet/reanalysis-parameter_1000.csv

cellranger reanalyze --id=Aggregate_normalized_reanalysis_3000cells \
                       --matrix=$ROOT/Aggregate_normalized/outs/filtered_feature_bc_matrix.h5 \
                       --params=$ROOT/SampleSheet/reanalysis-parameter_3000.csv

cellranger reanalyze --id=Aggregate_normalized_reanalysis_5000cells \
                       --matrix=$ROOT/Aggregate_normalized/outs/filtered_feature_bc_matrix.h5 \
                       --params=$ROOT/SampleSheet/reanalysis-parameter_5000.csv
                       
# End time
END=`date +%s`
MINUTES=$(((END-START)/60))
echo The run time was $MINUTES minutes.