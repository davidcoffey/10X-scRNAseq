# Secondary analysis using Seurat
# Yuexin Xu yxu2@fredhutch.org
# Updated May 2, 2019

## Prerequisites
# Install R
# Run Aggregate.sh from cellranger to merge expression matrix from multiple samples
# export SAMPLE and LOCUS environmental variables
# install.packages("Seurat")
# reticulate::py_install(packages ='umap-learn')

# Load required packages
library(Seurat)
library(ggplot2)
library(dplyr)
library(Matrix)

## load 10X data and creat object
genecount = Read10X(data.dir = Sys.getenv("MATRIX_DIRECTORY"))
pbmc <- CreateSeuratObject(counts = genecount)

## log normalization, output in slot "data"
pbmc <- NormalizeData(object = pbmc, normalization.method = "LogNormalize", scale.factor = 10000,
                      display.progress = TRUE)
write.csv(GetAssayData(object = pbmc, slot = 'data'), 
          paste(Sys.getenv("ROOT"), sep = "/Matrices/", "logNormalized.genecounts_seurat.csv"))

## Scales and centers features in the dataset, output slot = "scale.data"
pbmc <- ScaleData(object = pbmc)
write.csv(GetAssayData(object = pbmc, slot = 'scale.data'), 
          paste(Sys.getenv("ROOT"), sep = "/Matrices/", "scaled.genecounts_seurat.csv"))

## Find variable genes
pbmc <- FindVariableFeatures(object = pbmc)
# Identify the 10 most highly variable genes
top10 <- head(VariableFeatures(pbmc), 10)
# plot variable features with and without labels
plot1 <- VariableFeaturePlot(pbmc)
plot2 <- LabelPoints(plot = plot1, points = top10, repel = TRUE)
CombinePlots(plots = list(plot1, plot2))
ggsave(paste(Sys.getenv("ROOT"), sep = "/Seurat/", "top10_most_variable_genes.pdf"))
VlnPlot(pbmc,c("SDC1","TNFRSF17","CD38","CD4","CD8A","CD19"))
ggsave(paste(Sys.getenv("ROOT"), sep = "/Seurat/", "cellpopulation_genes.pdf"), width = 15)

## PCA
pbmc <- RunPCA(pbmc, verbose = FALSE)
pbmc <- FindNeighbors(pbmc, dims = 1:30, verbose = FALSE)
pbmc <- FindClusters(object = pbmc)
write.csv(Loadings(object = pbmc, reduction = "pca"), 
          paste(Sys.getenv("ROOT"), sep = "/Projections/", "pca_gene_seurat.csv"))
write.csv(Embeddings(object = pbmc, reduction = "pca"), 
          paste(Sys.getenv("ROOT"), sep = "/Projections/", "pca_cell_seurat.csv"))
VizDimLoadings(pbmc, dims = 1:2, reduction = "pca")
ggsave(paste(Sys.getenv("ROOT"), sep = "/Seurat/", "PC1_PC2_genes.pdf"))
DimPlot(pbmc, reduction = "pca")
ggsave(paste(Sys.getenv("ROOT"), sep = "/Seurat/", "PC1_PC2_scatterplot.pdf"))

# tSNE, Returns a Seurat object with a tSNE 
pbmc <- RunTSNE(object = pbmc, dims = 1:30, verbose = FALSE)
write.csv(Embeddings(object = pbmc, reduction = "tsne"), 
          file = paste(Sys.getenv("ROOT"), sep = "/Matrices/","tSNECoordinates_cell_seurat.csv"))
write.csv(Loadings(object = pbmc, reduction = "tsne"), 
          paste(Sys.getenv("ROOT"), sep = "/Projections/", "tSNECoordinates_gene_seurat.csv"))
DimPlot(object = pbmc, reduction = "tsne")
ggsave(paste(Sys.getenv("ROOT"), sep = "/Seurat/", "tSNE_scatterplot.pdf"))

# uMAP, Returns a Seurat object with a uMAP embedding 
pbmc <- RunUMAP(pbmc, dims = 1:30, verbose = FALSE)
write.csv(Embeddings(object = pbmc, reduction = "umap"), 
          file = paste(Sys.getenv("ROOT"), sep = "/Matrices/","uMAPCoordinates_cell_seurat.csv"))
write.csv(Loadings(object = pbmc, reduction = "umap"), 
          paste(Sys.getenv("ROOT"), sep = "/Projections/", "uMAPCoordinates_gene_seurat.csv"))
DimPlot(object = pbmc, reduction = "umap")
ggsave(paste(Sys.getenv("ROOT"), sep = "/Seurat/", "uMAP_scatterplot.pdf"))