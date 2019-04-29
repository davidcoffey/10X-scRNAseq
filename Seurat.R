# Secondary analysis using Seurat
# Yuexin Xu yxu2@fredhutch.org
# Updated April 23, 2019

## Prerequisites
# Install R
# Run Aggregate.sh from cellranger to merge expression matrix from multiple samples
# export SAMPLE and LOCUS environmental variables

# Load required packages
library(Seurat)

MM.data <- Read10X(data.dir = "/fh/fast/warren_h/users/dcoffey/scRNAseq/10X041619/Aggregate/outs/filtered_feature_bc_matrix")
pbmc4k <- CreateSeuratObject(counts = pbmc4k.data, project = "PBMC4K")
pbmc4k <- 