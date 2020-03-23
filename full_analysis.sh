#!/bin/bash

# 1st command line argument: the directory where you want the read data to go - this will be the directory with the species transcripts in too
# 2nd command line argument: the common SRA number between the runs
# 3rd command line argument: the numbers between which the SRA vaires, e.g. {2..5}
# 4th command line argument: the number of threads to use

data_directory=$1
SRA_concensous_number=$2
start_number=$3
end_number=$4
threads=$5
experiment_name=$6

bash get_SRA_data.sh $data_directory $SRA_concensous_number $start_number $end_number $threads &
bash create_salmon_index.sh $data_directory &
wait
bash salmon_quantify.sh $data_directory $SRA_concensous_number $start_number $end_number $threads
python concat_salmon_tables.py $data_directory/data $experiment_name
