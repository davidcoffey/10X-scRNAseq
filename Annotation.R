# BioMart convert gene name to ensemblID
# David Coffey
# March 1, 2016

library("biomaRt")

# Import gene list
T_cell_SC <- read.csv("/Users/yuexinxu1/Dropbox/10X/Annotation/T_cell_SC.csv")
T_cell_activation <- read.csv("/Users/yuexinxu1/Dropbox/10X/Annotation/T_cell_activation.csv")
Apoptosis <- read.csv("/Users/yuexinxu1/Dropbox/10X/Annotation/Hallmark_apoptosis.csv")
Bcell_MM <- read.csv("/Users/yuexinxu1/Dropbox/10X/Annotation/B_cell_MM.csv")

# List available marts
marts = listMarts()
marts

# List archived marts
listEnsemblArchives()
archived.marts = listMarts()
archived.marts

# Use archived mart
ensembl.51 = useMart("ensembl" )

# List datasets from archived mart
datasets.51 = listDatasets(ensembl.51)

# Use current mart
ensembl.83 = useMart("ENSEMBL_MART_ENSEMBL")

# List datasets from current mart
datasets.83 = listDatasets(ensembl.83)

# Use grch37
grch37 = useMart(biomart="ENSEMBL_MART_ENSEMBL", host="grch37.ensembl.org", path="/biomart/martservice", dataset="hsapiens_gene_ensembl")
grch37snp = useMart(biomart="ENSEMBL_MART_SNP", host="grch37.ensembl.org", dataset="hsapiens_snp")

# List filters and attributes
filters = listFilters(grch37)
attributes = listAttributes(grch37)

# Convert ensembl ID to gene symbol
getBM(filters = "ensembl_gene_id", attributes = c("hgnc_symbol", "ensembl_gene_id"), values = "ENSG00000136997", mart = grch37, uniqueRows = FALSE)

# Convert symbol to ensembl
T_cell_SC_Ensembl <- getBM(filters = "hgnc_symbol", attributes = c("hgnc_symbol", "ensembl_gene_id"), 
                          values = T_cell_SC$Name, mart = grch37, uniqueRows = FALSE)
T_cell_activation_Ensembl <- getBM(filters = "hgnc_symbol", attributes = c("hgnc_symbol", "ensembl_gene_id"), 
                                  values = T_cell_activation$Name, mart = grch37, uniqueRows = FALSE)
Apoptosis_Ensembl <- getBM(filters = "hgnc_symbol", attributes = c("hgnc_symbol", "ensembl_gene_id"), 
                           values = Apoptosis$Name, mart = grch37, uniqueRows = FALSE)
Bcell_MM_Ensemble <- getBM(filters = "hgnc_symbol", attributes = c("hgnc_symbol", "ensembl_gene_id"), 
                          values = Bcell_MM$Name, mart = grch37, uniqueRows = FALSE)
write.csv(T_cell_SC_Ensembl, "T_cell_SC_Ensembl.csv")
write.csv(T_cell_activation_Ensembl, "T_cell_activation_Ensembl.csv")
write.csv(Apoptosis_Ensembl, "Apoptosis_Ensembl.csv")
write.csv(Bcell_MM_Ensemble, "Bcell_MM_Ensemble.csv")

# Remove everything after . from ensmbl ID
gsub(pattern = "\\..*", replacement = "", x = "ENSG00000136997.10")