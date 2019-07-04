# Secondary data filtering using MAGIC
# Yuexin Xu yxu2@fredhutch.org
# Updated April 23, 2019

## Prerequisites
# Install R
if (!require(viridis)) install.packages("viridis")
if (!require(readr)) install.packages("readr")
if (!require(phateR)) install.packages("phateR")
if (!require(Rmagic)) install.packages("Rmagic")

## Enviranmental Variables
#export MATRIX="$MATRIX_DIRECTORY/Filtered_feature_bc_matrix.csv"
#export MAGIC="$ROOT/MAGIC"

# Load required packages
library(Rmagic)
library(readr)
library(ggplot2)
library(viridis)
library(phateR)

# Load dataset, trasform matrix to each cell as a row and each gene as a column
# data <- read.csv("/Users/yuexinxu1/Documents/10x david/Filtered_expression_matrix.csv")
data <- read.csv(Sys.getenv("MATRIX"))
row.names(data) <- data$X
data$X <- NULL
data <- as.data.frame(t(data))

## Filtering data
# keep genes expressed in at least 10 cells
keep_cols <- colSums(data > 0) > 10
data <- data[,keep_cols]

# look at the distribution of library sizes
ggplot() +
  geom_histogram(aes(x=rowSums(data)), bins=50) +
  geom_vline(xintercept = 1000, color='red')

if (FALSE) {
  # keep cells with at least 1000 UMIs and at most 15000
  keep_rows <- rowSums(data) > 1000 & rowSums(data) < 15000
  data <- data[keep_rows,]
}

## Normalizing data
# Transform the data with either log or square root. The log transform is commonly used, which requires adding a “pseudocount” to avoid log(0). 
# We normally square root instead, which has a similar form but doesn’t suffer from instabilities at zero. For small dataset, though, it is not necessary as the distribution of gene expression is not too extreme.

data <- library.size.normalize(data)
if (FALSE) {
  data <- sqrt(data)
}

## Running MAGIC
# Can increase knn from the default of 10 up to 15.
data_MAGIC <- magic(data, genes="all_genes", knn=10)
write.csv(data_MAGIC, file=paste(Sys.getenv("MATRIX"), sep = "/", "MAGIC_transformed_matrix.csv"))

ggplot(data) +
  geom_point(aes(CD8a, GZMB, color=PDCD1)) +
  scale_color_viridis(option="B")
ggsave(paste(Sys.getenv("MAGIC"), sep = "/", "EMT_data_R_before_magic.png"), width=5, height=5)

ggplot(data_MAGIC) +
  geom_point(aes(CD8a, GZMB, color=PDCD1)) +
  scale_color_viridis(option="B")
ggsave(paste(Sys.getenv("MAGIC"), sep = "", "EMT_data_R_after_magic.png"), width=5, height=5)

## Visualizing MAGIC values on PCA
data_MAGIC_PCA <- magic(data, genes="pca_only", 
                        knn=15, init=data_MAGIC)
ggplot(data_MAGIC_PCA) +
  geom_point(aes(x=PC1, y=PC2, color=data_MAGIC$result$PDCD1)) +
  scale_color_viridis(option="B") +
  labs(color="PDCD1")
ggsave(paste(Sys.getenv("MAGIC"), sep = "", "EMT_data_R_pca_colored_by_magic.png"), width=5, height=5)

## Visualizing MAGIC values on PHATE
data_PHATE <- phate(magic_testdata, knn=3, t=15)
ggplot(data_PHATE) +
  geom_point(aes(x=PHATE1, y=PHATE2, color=data_MAGIC$result$PDCD1)) +
  scale_color_viridis(option="B") +
  labs(color="PDCD1")
ggsave(paste(Sys.getenv("MAGIC"), sep = "", "EMT_data_R_PHATE_colored_by_magic.png"), width=5, height=5)





