#!/usr/bin/awk -f

### HOW THIS SCRIPT WORKS ###
# This script takes a TPM file (tab delimited data) and sums the TPM scores of gene models for the same gene
# Different species have different naming conventions for genes
# Typically though the name of the gene comes first and then the varying gene models are discerned by a delimiter (e.g. "_") and a number
# This script therefore takes two command line variables "delim" and "ind"

# e.g. cat maize_TPM_data | awk -v delim="_" -v ind=1 -f concat_gene_model_reads.awk

# delim specifies the delimiter by which the gene model number is determined
# index specifies the delimiter (by its occurence) that splits the gene name from the gene model number

# e.g GRMZM5G844236_T01 has a delim of "_" and a ind of 1

# Skip the first line
NR==1 { print; next }

{
  # for the current line, look at the gene in column 1
  curr = $1

  # set curr to the collective gene model name
  split(curr, arr, delim)
  temp = arr[1]
  for (i = 2; i <= ind; i++) {
      temp = temp""delim""arr[i]
    }

  curr = temp

  # if the gene ID is not the same row before, print the summed values (if appropriate) of the prev id and start summing any shared values for the curr ID
  if ( curr != prev ) {
    prt()
  }

  for (i=2; i<=NF; i++) {
    sum[i] += $i
  }

  prev = curr
}

END { prt() }

function prt() {
  if (prev != "" ) {
    printf "%s%s", prev, OFS
    for (i=2; i<=NF; i++) {
      printf "%0.2f%s", sum[i], (i<NF ? OFS : ORS)
    }
    delete sum
  }
}
