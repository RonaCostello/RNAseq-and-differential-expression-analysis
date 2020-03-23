library(DESeq2)
library(tximport)
library(readr)

summary_statistics <- function(res, filter) {
  number_DE_genes <- sum(res$padj < alpha, na.rm=TRUE)
  print(sprintf("Number of DE expressed genes for %s is:", filter))
  print(number_DE_genes)
  print(sprintf("Summary for results using %s:", filter))
  print(summary(res))
}

samples <- read.table("DE_analysis/SRA047278_metadata.csv", header = TRUE)

tx2gene <- read_csv("DE_analysis/tx2gene.csv") ## manually created dict of gene transcripts to locus

files <- file.path(getwd(), sprintf("%s_quant", samples$Run), "quant.sf")

stopifnot(all(file.exists(files)))

names(files) <- samples$Run

txi <- tximport(files, type = "salmon", tx2gene = tx2gene)

head(txi$counts)



sampleTable <- data.frame(condition = factor(rep(c("M", "BS"), each = 2))) # each is the number of replicates per condition

rownames(sampleTable) <- colnames(txi$counts)

dds <- DESeqDataSetFromTximport(txi, sampleTable, ~condition)

dds <- DESeq(dds)

## Results using DESeq2 Independent Filtering (based on optimisation of number of DE genes given a p value threshold (alpha))
alpha <- 0.05
res1 <- results( dds, alpha=alpha )
summary_statistics(res1, "DESeq2 filter")
write.csv( as.data.frame( res1 ), file="DE_analysis/results.csv" )

## Results using predefined cutoff based on the mean of normalised counts (baseMean) of a gene
cutoff <- 2.0
dds_filtered <- dds[ res1$baseMean > cutoff, ]
res2 <- results(dds_filtered, independentFiltering = FALSE)
summary_statistics(res2, "my baseMean cutoff")
write.csv( as.data.frame( res2 ), file = sprintf("DE_analysis/results_filtered_baseMean_%s.csv", toString(cutoff)) )
