# DESeq2 uses the TPM file of all transcripts for analysis (it concats the gene models itself)
# But for it to deliminate the different gene models a file is needed that links each gene model to the common gene ID
# This script creates the necessary file for this

# 1st command line argument: the TPM file of merged TPMs (but not merged gene models). E.g. 'ERP013053_S.bicolor-M-BS_merged_TPMs.csv'
# 2nd command line argument: the delimiter by which the different gene models are seperated
# 3rd command line argument: the position of the delimiter in defining the different gene models (if for example there are multiple '.' in the gene IDs). Index starts at 1.
# 4th command line argument: the directory where the output file should be saved

import pandas as pd
import sys

TPM_file = sys.argv[1]
delimiter = sys.argv[2]
delimiter_position = int(sys.argv[3])
output_directory = sys.argv[4]

gene_model_df = pd.read_csv(TPM_file, sep= '\t', usecols = ['Name'])


gene_model_df['GENEID'] = gene_model_df.Name.str.split(pat=delimiter, n=delimiter_position)
gene_model_df['GENEID'] = gene_model_df['GENEID'].apply(lambda x: x[0:-1])
gene_model_df['GENEID'] = gene_model_df['GENEID'].str.join(delimiter)

gene_model_df.columns = ['TXNAME', 'GENEID']

gene_model_df.to_csv(f'{output_directory}/tx2gene.csv', sep=',', index=None, header=True)
