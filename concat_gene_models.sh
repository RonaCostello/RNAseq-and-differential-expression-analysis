#!/bin/bash

data_directory=$1
experiment_name=$2
delimiter=$3
index=$4

# For a description of the command line variables, see the awk script

{ head -n 1 $data_directory"/"$experiment_name"_merged_TPMs.csv"; tail -n +2 $data_directory"/"$experiment_name"_merged_TPMs.csv" | sort;} | awk -v delim=$delimiter -v ind=$index -f concat_gene_model_reads.awk > $data_directory"/"$experiment_name"_merged_TPMs_concated_gene_models.csv"
