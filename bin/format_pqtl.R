#!/usr/bin/env Rscript
args <- commandArgs(trailingOnly = TRUE)

# Load libraries (vroom to open/write large files,
# dplyr and tidyr to format data)
library(vroom)
library(dplyr)
library(MungeSumstats)

input_path <- args[1]
output_path <- args[2]
sumstats_path <- args[3]

dep <- vroom(sumstats_path)

pqtl <- vroom(input_path)

out <- pqtl %>%
  select(c("CHROM", "GENPOS", "ALLELE0", "ALLELE1",
           "A1FREQ", "N", "BETA", "SE", "LOG10P"))

out <- out %>%
  inner_join(dep[, c("SNP", "CHR", "BP", "A1", "A2")],
             by = c("CHROM" = "CHR", "GENPOS" = "BP", "ALLELE0" = "A2",
                    "ALLELE1" = "A1")) %>%
  select(SNP, everything())

out$p <- 10^(-1 * as.numeric(out$LOG10P))

colnames(out) <- c("SNP", "CHR", "BP", "A2", "A1", "FREQ",
                   "N", "BETA", "SE", "LOG10P", "P")

lift <- liftover(
  out,
  "GRCh37",
  "GRCh38",
  chain_source = "ensembl",
  imputation_ind = TRUE,
  chrom_col = "CHR",
  start_col = "BP",
  end_col = "BP",
  as_granges = FALSE,
  style = "NCBI",
  verbose = TRUE
)

lift <- lift %>%
  select(SNP, A1, A2, freq = FREQ, b = BETA, se = SE, p = P, n = N)

vroom_write(lift, output_path)
