# 10X scRNAseq Pipeline v1.0
#### Updated July 2, 2019
These are a series of shell and R scripts used to process single cell RNAseq files using the 10X Genomics library construction kit.

For 5' gene expression, the general sequence that the files are run in are as follows:
1. MakeFastQ.sh
2. Counts.sh
3. Aggregate.sh
4. MAGIC.R

For V(D)J analysis, the general sequence that the files are run in are as follows:
1. MakeFastQ.sh
2. VDJ.sh
