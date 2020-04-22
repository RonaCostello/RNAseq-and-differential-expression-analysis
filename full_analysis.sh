#!/bin/bash

# 1st command line argument: the directory where you want the read data to go - this will be the directory with the species transcripts in too
# 2nd command line argument: the common SRA number between the runs
# 3rd command line argument: the numbers between which the SRA vaires, e.g. {2..5}. First number here, e.g. 2
# 4rd command line argument: the numbers between which the SRA vaires, e.g. {2..5}. First number here, e.g. 5
# 5th command line argument: the number of threads to use
# 6th command line argument: the unique experiment name or SRA bioproject number
# 7th command line argument: Specify if reads are paired end or single end, 'PE' or 'SE'
# 8th command line argument: The delimiter by which different gene models are specified. e.g. for GRMZM5G844236_T01 the delimiter is '_'
# 9th command line argument: The position of the above delimiter in case more than one occurs in the name. In the above example the delimiter is 1

data_directory=$1
SRA_concensous_number=$2
start_number=$3
end_number=$4
threads=$5
experiment_name=$6
read_type=$7
delimiter=$8
index=$9


bash get_SRA_data.sh $data_directory $SRA_concensous_number $start_number $end_number $threads $read_type &
wait
bash create_salmon_index.sh $data_directory &
wait
bash salmon_quantify.sh $data_directory $SRA_concensous_number $start_number $end_number $threads $read_type &
wait
python concat_salmon_tables.py $data_directory/data $experiment_name
wait
bash concat_gene_models.sh $data_directory/data $experiment_name $delimiter $index
