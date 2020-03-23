#!/bin/bash

# 1st command line argument: the directory where you want the read data to go - this will be the directory with the species transcripts in too
# 2nd command line argument: the common SRA number between the runs
# 3rd command line argument: the numbers between which the SRA vaires, e.g. {2..5}
# 4th command line argument: the number of threads to use (default = 6)

data_directory=$1
SRA_concensous_number=$2
start_number=$3
end_number=$4
threads=$5

cd $data_directory/data

for i in $(seq $start_number $end_number)
	do
		echo Processing sample $SRA_concensous_number$((i));
		salmon quant -i ../salmon_index/ -l A --gcBias \
			-1 $SRA_concensous_number$((i))/$SRA_concensous_number$((i))_1_trimmed.fq \
			-2 $SRA_concensous_number$((i))/$SRA_concensous_number$((i))_2_trimmed.fq \
			-p $threads --validateMappings -o $SRA_concensous_number$((i))_quant;

		cp $SRA_concensous_number$((i))_quant/quant.sf ./$SRA_concensous_number$((i))_quant.sf
		echo Copied $SRA_concensous_number$((i))_quant file to data directory
done
