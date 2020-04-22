#!/bin/bash

# 1st command line argument: the directory where you want the read data to go - this will be the directory with the species transcripts in too
# 2nd command line argument: the common SRA number between the runs
# 3rd command line argument: the numbers between which the SRA vaires, e.g. {2..5}
# 4th command line argument: the number of threads to use (default = 6)
# 6th command line argument: the unique experiment name or SRA bioproject number
# 7th command line argument: Specify if reads are paired end or single end, 'PE' or 'SE'

data_directory=$1
SRA_concensous_number=$2
start_number=$3
end_number=$4
threads=$5
read_type=$6

cd $data_directory
mkdir data
cd data

for i in $(seq $start_number $end_number)
	do
		mkdir $SRA_concensous_number$i
		cd $SRA_concensous_number$i
		echo fetching $SRA_concensous_number$i read data
		fasterq-dump $SRA_concensous_number$i

		if [$read_type == 'PE']; then
			trimmomatic PE -threads $threads $SRA_concensous_number$((i))_1.fastq $SRA_concensous_number$((i))_2.fastq $SRA_concensous_number$((i))_1_trimmed.fq $SRA_concensous_number$((i))_1_trimmed_unpaired.fq $SRA_concensous_number$((i))_2_trimmed.fq $SRA_concensous_number$((i))_2_trimmed_unpaired.fq ILLUMINACLIP:../../../shell_scripts/all_adaptors.fasta:2:30:10 LEADING:20 TRAILING:20 SLIDINGWINDOW:5:20 HEADCROP:1 MINLEN:35
		elif [$read_type == 'SE']; then
			trimmomatic SE -threads $threads $SRA_concensous_number$((i)).fastq $SRA_concensous_number$((i))_trimmed.fq ILLUMINACLIP:../../../shell_scripts/all_adaptors.fasta:2:30:10 LEADING:20 TRAILING:20 SLIDINGWINDOW:5:20 HEADCROP:1 MINLEN:35
		else
			echo 'read type (paired or single end) not given correctly, exiting script'
			exit 1
		cd ..
done
cd ..
