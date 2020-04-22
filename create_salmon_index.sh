#!/bin/bash

# 1st command line argument: the directory where you want the read data to go - this will be the directory with the species transcripts in too
# Make sure the transcript file in a fa.gz file, and there are no other files with this extension in the directory

cd $1

if [ -f *fa.gz ]
  then
    echo "transcript.fa.gz found, creating index with Salmon"
    salmon index -t *fa.gz -i salmon_index
  else
    echo "no transcript.fa.gz found so no salmon index being made, script exiting"
    exit 1
fi
