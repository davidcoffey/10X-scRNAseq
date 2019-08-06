# Combine VDJ statistics
# David Coffey dcoffey@fredhutch.org
# Updated August 6, 2019

library(data.table)
library(plyr)
library(tidyr)
library(readxl)

run = basename(Sys.getenv("ROOT"))
path = paste(Sys.getenv("ROOT"), "Links", sep = "/")

# Merge all contig annotations
files = list.files(paste(path, "All_contig_annotations", sep = "/"), full.names = TRUE)
all.contigs = plyr::llply(files, data.table::fread, data.table = FALSE, .progress = "text")
names(all.contigs) = gsub(x = basename(files), pattern = ".all_contig_annotations.csv", replacement = "")
all.contigs = plyr::ldply(all.contigs, data.frame, .id = "library")
all.contigs$SampleID = gsub(all.contigs$library, pattern = "_TCR|_BCR", replacement = "")
write.csv(all.contigs, file = paste(path, "/Combined/", run, "_all.contigs.csv", sep = ""), row.names = FALSE)

# Merge clonotypes
files = list.files(paste(path, "Clonotypes", sep = "/"), full.names = TRUE)
clonotypes = plyr::llply(files, data.table::fread, data.table = FALSE, .progress = "text")
names(clonotypes) = gsub(x = basename(files), pattern = ".clonotypes.csv", replacement = "")
clonotypes = plyr::ldply(clonotypes, data.frame, .id = "library")
clonotypes$SampleID = gsub(clonotypes$library, pattern = "_TCR|_BCR", replacement = "")
clonotypes$receptor = ifelse(grepl(clonotypes$cdr3s_aa, pattern = "TR"), "TCR", "BCR")
write.csv(clonotypes, file = paste(path, "/Combined/", run, "_clonotypes.csv", sep = ""), row.names = FALSE)

# Merge consensus annotations
files = list.files(paste(path, "Consensus_annotations", sep = "/"), full.names = TRUE)
consensus.annotations = plyr::llply(files, data.table::fread, data.table = FALSE, .progress = "text")
names(consensus.annotations) = gsub(x = basename(files), pattern = ".consensus_annotations.csv", replacement = "")
consensus.annotations = plyr::ldply(consensus.annotations, data.frame, .id = "library")
consensus.annotations$SampleID = gsub(consensus.annotations$library, pattern = "_TCR|_BCR", replacement = "")
write.csv(consensus.annotations, file = paste(path, "/Combined/", run, "_consensus_annotations.csv", sep = ""), row.names = FALSE)

# Merge filtered contig annotations
files = list.files(paste(path, "Filtered_contig_annotations", sep = "/"), full.names = TRUE)
filtered.contig.annotations = plyr::llply(files, data.table::fread, data.table = FALSE, .progress = "text")
names(filtered.contig.annotations) = gsub(x = basename(files), pattern = ".filtered_contig_annotations.csv", replacement = "")
filtered.contig.annotations = plyr::ldply(filtered.contig.annotations, data.frame, .id = "library")
filtered.contig.annotations$SampleID = gsub(filtered.contig.annotations$library, pattern = "_TCR|_BCR", replacement = "")
write.csv(filtered.contig.annotations, file = paste(path, "/Combined/", run, "_filtered_contig_annotations.csv", sep = ""), row.names = FALSE)

# Merge VDJ metric summary
files = list.files(paste(path, "Metrics_summary", sep = "/"), full.names = TRUE)
files = files[grepl(files, pattern = "TCR|BCR")]
metrics.summary.VDJ = plyr::llply(files, data.table::fread, data.table = FALSE, .progress = "text")
names(metrics.summary.VDJ) = gsub(x = basename(files), pattern = ".metrics_summary.csv", replacement = "")
metrics.summary.VDJ = plyr::ldply(metrics.summary.VDJ, data.frame, .id = "library")
metrics.summary.VDJ$Enrichment = ifelse(grepl(metrics.summary.VDJ$library, pattern = "TCR"), "TCR", "BCR")
metrics.summary.VDJ$SampleID = gsub(metrics.summary.VDJ$library, pattern = "_TCR|_BCR", replacement = "")
write.csv(metrics.summary.VDJ, file = paste(path, "/Combined/", run, "_metrics_summary_VDJ_by_library.csv", sep = ""), row.names = FALSE)

# Create contig file of clonotypes
clonotype.contigs = all.contigs[all.contigs$high_confidence == TRUE & 
                                  all.contigs$is_cell == TRUE & 
                                  all.contigs$raw_clonotype_id != "None" &
                                  all.contigs$productive != "None" & 
                                  all.contigs$raw_consensus_id != "None", ]
clonotype.contigs$receptor = ifelse(grepl(clonotype.contigs$chain, pattern = "TR"), "TCR", "BCR")
write.csv(clonotype.contigs, file = paste(path, "/Combined/", run, "_clonotype_contigs.csv", sep = ""), row.names = FALSE)

# Spread CDR3 across chains by barcode and clonotype
aggregate.chains = aggregate(data = clonotype.contigs, cdr3~library+SampleID+raw_clonotype_id+chain+barcode, paste, collapse = ",")
aggregate.chains.count = aggregate(data = clonotype.contigs, cdr3~library+raw_clonotype_id+SampleID+chain+barcode, length)
names(aggregate.chains.count)[6] = "multi_chain"
aggregate.chains = merge(aggregate.chains, aggregate.chains.count)
spread.chains = spread(aggregate.chains, chain, cdr3, fill= "")
spread.chains$doublet = ifelse((spread.chains$IGH != "" | spread.chains$IGK != "" | spread.chains$IGL != "") &
                                 (spread.chains$TRB != "" | spread.chains$TRA != ""), TRUE, FALSE)
write.csv(spread.chains, file = paste(path, "/Combined/", run, "_clonotype_contigs_one_clone_per_row.csv", sep = ""), row.names = FALSE)