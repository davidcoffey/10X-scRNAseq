# Combine gene expression metrics
# David Coffey dcoffey@fredhutch.org
# Updated May 29, 2019

library(data.table)
library(plyr)

#path = "/Volumes/homes/Warren_FAST/users/dcoffey/scRNAseq/10X051519/Links"
#run = "10X051519
run = basename(Sys.getenv("ROOT"))
path = paste(Sys.getenv("ROOT"), "Links", sep = "/")

# Import GEx
files = list.files(paste(path, "Metrics_summary", sep = "/"), full.names = TRUE)
files = files[!(grepl(files, pattern = "TCR|BCR"))]
metrics.summary.GEx = plyr::llply(files, data.table::fread, data.table = FALSE, .progress = "text")
names(metrics.summary.GEx) = gsub(x = basename(files), pattern = ".metrics_summary.csv", replacement = "")
metrics.summary.GEx = plyr::ldply(metrics.summary.GEx, data.frame, .id = "SampleID")
metrics.summary.GEx[,-1] <- sapply(metrics.summary.GEx[,-1], function(x) as.numeric(gsub(",|%", "", x)))
write.csv(metrics.summary.GEx, file = paste(path, "/Combined/", run, "_metrics_summary_GEx.csv", sep = ""), row.names = FALSE)