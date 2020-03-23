
# # Collate RNAseq data from multiple sequencing runs

import os
import pandas
import glob
import sys

def concat_dfs(directory):

    '''This function takes the salmon files (*_quant.sf) from a directory and concats the TPM scores for each gene, returning them as a new dataframe'''

    os.chdir(os.path.join(os.getcwd(), directory))

    list_of_dfs = []

    for i, fn in enumerate(glob.glob('*_quant.sf')):
        if i == 0:
            df = pandas.read_csv(fn, sep='\t', usecols=['Name', 'Length', 'EffectiveLength', 'TPM'], index_col='Name')
        else:
            df = pandas.read_csv(fn, sep='\t', usecols=['Name', 'TPM'], index_col='Name')

        df.rename(columns={'TPM': f'{fn[:-9]}_TPM'}, inplace=True)

        list_of_dfs.append(df)

    return(pandas.concat(list_of_dfs, axis=1))

def main():
    '''Write new dataframe to tab-delimited file'''

    # The directory of the data files is given as the first command line argument
    data_directory = sys.argv[1]
    experiment_name = sys.argv[2]

    new_df = concat_dfs(data_directory)
    new_df.to_csv(f'{experiment_name}_merged_TPMs.csv', sep='\t')

    print(f'New file "{experiment_name}_merged_TPMs.csv" created')

if __name__ == '__main__':
    main()
