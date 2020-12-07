#!/bin/bash
# Variation partition
# David Coffey dcoffey@fredhutch.org
# December 6, 2020

# Define universal variables
export ROOT="/fh/fast/warren_h/users/dcoffey/scRNAseq/10XMMRFINE"

# Variation partition
ml monocle3/0.2.2-foss-2019b-R-4.0.2
export INDICES="1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31"

for I in ${INDICES}; do
echo ${I}
export INDEX=${I}
sbatch -n 1 -c 6 -t 2-0 -c 6 --job-name="VPA" --wrap="Rscript $ROOT/Scripts/VariationPartitionAzimuth.R" --output=$ROOT/Logs/VPazimuth.${I}.log
done

ml monocle3/0.2.2-foss-2019b-R-4.0.2
export INDICES="1 2 3 4 5 6 7 8 9 10"

for I in ${INDICES}; do
echo ${I}
export INDEX=${I}
sbatch -n 1 -c 4 -t 2-0 --job-name="VPAP" --wrap="Rscript $ROOT/Scripts/VariationPartitionAzimuthParent.R" --output=$ROOT/Logs/VPazimuthParent.${I}.log
done

# Variation partition
ml monocle3/0.2.2-foss-2019b-R-4.0.2
export INDICES="1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29"

for I in ${INDICES}; do
echo ${I}
export INDEX=${I}
sbatch -n 1 -c 4 -t 2-0 --job-name="VPG" --wrap="Rscript $ROOT/Scripts/VariationPartitionGarnett.R" --output=$ROOT/Logs/VPgarnett.${I}.log
done

ml monocle3/0.2.2-foss-2019b-R-4.0.2
export INDICES="1 2 3 4 5 6 7"

for I in ${INDICES}; do
echo ${I}
export INDEX=${I}
sbatch -n 1 -c 4 -t 2-0 --job-name="VPGP" --wrap="Rscript $ROOT/Scripts/VariationPartitionGarnettParent.R" --output=$ROOT/Logs/VPgarnettParent.${I}.log
done
