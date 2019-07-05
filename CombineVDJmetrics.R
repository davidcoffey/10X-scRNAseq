# Combine VDJ statistics
# David Coffey dcoffey@fredhutch.org
# Updated May 29, 2019

library(data.table)
library(plyr)

#path = "/Volumes/homes/Warren_FAST/users/dcoffey/scRNAseq/10X051519/Links"
#run = "10X051519
run = basename(Sys.getenv("ROOT"))
path = paste(Sys.getenv("ROOT"), "Links", sep = "/")

# Import V(D)J files
files = list.files(paste(path, "All_contig_annotations", sep = "/"), full.names = TRUE)
all.contigs = plyr::llply(files, data.table::fread, data.table = FALSE, .progress = "text")
names(all.contigs) = gsub(x = basename(files), pattern = ".all_contig_annotations.csv", replacement = "")
all.contigs = plyr::ldply(all.contigs, data.frame, .id = "library")
all.contigs$SampleID = gsub(all.contigs$library, pattern = "_TCR|_BCR", replacement = "")
write.csv(all.contigs, file = paste(path, "/Combined/", run, "_all.contigs.csv", sep = ""), row.names = FALSE)

files = list.files(paste(path, "Clonotypes", sep = "/"), full.names = TRUE)
clonotypes = plyr::llply(files, data.table::fread, data.table = FALSE, .progress = "text")
names(clonotypes) = gsub(x = basename(files), pattern = ".clonotypes.csv", replacement = "")
clonotypes = plyr::ldply(clonotypes, data.frame, .id = "library")
clonotypes$SampleID = gsub(clonotypes$library, pattern = "_TCR|_BCR", replacement = "")
clonotypes$receptor = ifelse(grepl(clonotypes$cdr3s_aa, pattern = "TR"), "TCR", "BCR")
write.csv(clonotypes, file = paste(path, "/Combined/", run, "clonotypes.csv", sep = ""), row.names = FALSE)

files = list.files(paste(path, "Consensus_annotations", sep = "/"), full.names = TRUE)
consensus.annotations = plyr::llply(files, data.table::fread, data.table = FALSE, .progress = "text")
names(consensus.annotations) = gsub(x = basename(files), pattern = ".consensus_annotations.csv", replacement = "")
consensus.annotations = plyr::ldply(consensus.annotations, data.frame, .id = "library")
consensus.annotations$SampleID = gsub(consensus.annotations$library, pattern = "_TCR|_BCR", replacement = "")
write.csv(consensus.annotations, file = paste(path, "/Combined/", run, "consensus_annotations.csv", sep = ""), row.names = FALSE)

files = list.files(paste(path, "Filtered_contig_annotations", sep = "/"), full.names = TRUE)
filtered.contig.annotations = plyr::llply(files, data.table::fread, data.table = FALSE, .progress = "text")
names(filtered.contig.annotations) = gsub(x = basename(files), pattern = ".filtered_contig_annotations.csv", replacement = "")
filtered.contig.annotations = plyr::ldply(filtered.contig.annotations, data.frame, .id = "library")
filtered.contig.annotations$SampleID = gsub(filtered.contig.annotations$library, pattern = "_TCR|_BCR", replacement = "")
write.csv(filtered.contig.annotations, file = paste(path, "/Combined/", run, "filtered_contig_annotations.csv", sep = ""), row.names = FALSE)

files = list.files(paste(path, "Metrics_summary", sep = "/"), full.names = TRUE)
files = files[grepl(files, pattern = "TCR|BCR")]
metrics.summary.VDJ = plyr::llply(files, data.table::fread, data.table = FALSE, .progress = "text")
names(metrics.summary.VDJ) = gsub(x = basename(files), pattern = ".metrics_summary.csv", replacement = "")
metrics.summary.VDJ = plyr::ldply(metrics.summary.VDJ, data.frame, .id = "library")
metrics.summary.VDJ$Enrichment = ifelse(grepl(metrics.summary.VDJ$library, pattern = "TCR"), "TCR", "BCR")
metrics.summary.VDJ$SampleID = gsub(metrics.summary.VDJ$library, pattern = "_TCR|_BCR", replacement = "")
write.csv(metrics.summary.VDJ, file = paste(path, "/Combined/", run, "metrics_summary_VDJ.csv", sep = ""), row.names = FALSE)

