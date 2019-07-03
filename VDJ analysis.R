# VDJ Analysis
# David Coffey dcoffey@fredhutch.org
# Updated May 10, 2019

library(plyr)
library(dplyr)
library(data.table)
library(ggplot2)
library(plotly)
library(pheatmap)
library(UpSetR)

root = "/Volumes/homes/Warren_FAST/users/dcoffey/scRNAseq/10X041619/Links"

# Import files
files = list.files(paste(root, "All_contig_annotations", sep = "/"), full.names = TRUE)
all.contigs = plyr::llply(files, data.table::fread, data.table = FALSE, .progress = "text")
names(all.contigs) = gsub(x = basename(files), pattern = ".all_contig_annotations.csv", replacement = "")
all.contigs = ldply(all.contigs, data.frame, .id = "sample")

files = list.files(paste(root, "Clonotypes", sep = "/"), full.names = TRUE)
clonotypes = plyr::llply(files, data.table::fread, data.table = FALSE, .progress = "text")
names(clonotypes) = gsub(x = basename(files), pattern = ".clonotypes.csv", replacement = "")
clonotypes = ldply(clonotypes, data.frame, .id = "sample")

files = list.files(paste(root, "Consensus_annotations", sep = "/"), full.names = TRUE)
consensus.annotations = plyr::llply(files, data.table::fread, data.table = FALSE, .progress = "text")
names(consensus.annotations) = gsub(x = basename(files), pattern = ".consensus_annotations.csv", replacement = "")
consensus.annotations = ldply(consensus.annotations, data.frame, .id = "sample")

files = list.files(paste(root, "Filtered_contig_annotations", sep = "/"), full.names = TRUE)
filtered.contig.annotations = plyr::llply(files, data.table::fread, data.table = FALSE, .progress = "text")
names(filtered.contig.annotations) = gsub(x = basename(files), pattern = ".filtered_contig_annotations.csv", replacement = "")
filtered.contig.annotations = ldply(filtered.contig.annotations, data.frame, .id = "sample")

files = list.files(paste(root, "Metrics_summary", sep = "/"), full.names = TRUE)
metrics.summary = plyr::llply(files, data.table::fread, data.table = FALSE, .progress = "text")
names(metrics.summary) = gsub(x = basename(files), pattern = ".metrics_summary.csv", replacement = "")
metrics.summary = ldply(metrics.summary, data.frame, .id = "sample")

# Receptor chain distribution by sample
sample.chain.counts = data.table(table(filtered.contig.annotations$sample, filtered.contig.annotations$chain))
names(sample.chain.counts) = c("sample", "chain", "count")

ggplot(sample.chain.counts, aes(x = sample, y = count, fill = chain)) +
  geom_bar(stat = "identity") +
  scale_fill_brewer(palette = "Set1") +
  labs(x = "", y = "Clonotypes", fill = "Chain")

sample.chain.proportional = data.frame(prop.table(table(filtered.contig.annotations$sample, filtered.contig.annotations$chain), 1))
names(sample.chain.proportional) = c("sample", "chain", "proportion")

ggplot(sample.chain.proportional, aes(x = sample, y = proportion, fill = chain)) +
  geom_bar(stat = "identity") +
  scale_fill_brewer(palette = "Set1") +
  scale_x_discrete(limits = c("201687_6B_0_BCR", "202823_6P_0_BCR", "333196_6B_1_BCR",  "333224_6P_1_BCR",
                              "333196_6B_1_TCR", "201687_6B_0_TCR", "202823_6P_0_TCR", "333224_6P_1_TCR")) +
  #scale_x_discrete(limits = c("201687_6B_0_BCR", "333196_6B_1_BCR", "202823_6P_0_BCR", "333224_6P_1_BCR",
  #                            "201687_6B_0_TCR", "333196_6B_1_TCR", "202823_6P_0_TCR", "333224_6P_1_TCR")) +
  labs(x = "", y = "Clonotypes", fill = "Chain")

# Look for T and B cells that share the same barcode
filtered.contig.annotations$library = ifelse(grepl(filtered.contig.annotations$sample, pattern = "BCR"), "BCR", "TCR")
shared.barcodes = intersect(filtered.contig.annotations[filtered.contig.annotations$library == "BCR", "barcode"], filtered.contig.annotations[filtered.contig.annotations$library == "TCR", "barcode"])
filtered.contig.annotations.shared = filtered.contig.annotations[filtered.contig.annotations$barcode %in% shared.barcodes,]
matrix.shared = as.data.frame.matrix(table(filtered.contig.annotations.shared$barcode, filtered.contig.annotations.shared$sample))

pheatmap(matrix.shared, show_rownames = FALSE)

matrix.shared[matrix.shared > 0] <- 1
upset(data = matrix.shared)


