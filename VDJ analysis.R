# VDJ Analysis
# David Coffey dcoffey@fredhutch.org
# Updated May 10, 2019

library(plyr)
library(dplyr)
library(data.table)
library(ggplot2)

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
sample.chain = data.table(table(filtered.contig.annotations$Sample, filtered.contig.annotations$chain))
names(sample.chain) = c("sample", "chain", "count")

ggplot(sample.chain, aes(x = sample, y = count, fill = chain)) +
  geom_bar(stat = "identity") +
  scale_fill_brewer(palette = "Set1") +
  labs(x = "", y = "Clonotypes", fill = "Chain")

sample.chain.group = group_by(sample.chain, sample, chain)
sample.chain.sum = summarise(sample.chain.group, sum = sum(count), ecdf = ecdf(count)(unique(sample)))

