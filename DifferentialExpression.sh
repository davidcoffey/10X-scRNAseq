#!/bin/bash
# Differential expression
# David Coffey dcoffey@fredhutch.org
# December 6, 2020

# Define universal variables
export ROOT="/fh/fast/warren_h/users/dcoffey/scRNAseq/10XMMRFINE"

# Differential gene expression
ml monocle3/0.2.2-foss-2019b-R-4.0.2
export INDICES="1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31"

for I in ${INDICES}; do
echo ${I}
export INDEX=${I}
sbatch -n 1 -c 4 -t 2-0 --job-name="DE3" --wrap="Rscript $ROOT/Scripts/DifferentialExpression3.R" --output=$ROOT/Logs/DE3.${I}.log
done

# Differential gene expression
ml monocle3/0.2.2-foss-2019b-R-4.0.2
export INDICES="1 2 3 4 5 6 7 8 9 10"

for I in ${INDICES}; do
echo ${I}
export INDEX=${I}
sbatch -n 1 -c 4 -t 2-0 --job-name="DE4" --wrap="Rscript $ROOT/Scripts/DifferentialExpression4.R" --output=$ROOT/Logs/DE4.${I}.log
done
