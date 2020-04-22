#!/bin/bash

TPM_file=$1
delimiter=$2
index=$3
output_file=$4

# For a description of the command line variables, see the awk script

{ head -n 1 $TPM_file; tail -n +2 $TPM_file | sort; } | awk -v delim=$delimiter -v ind=$index -f concat_gene_model_reads.awk > $output_file
