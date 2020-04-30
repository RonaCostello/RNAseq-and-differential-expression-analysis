# Check the quality between sample read correlation

# Written for merged TPM files that have also had their gene model reads concatenated with my other script. Although should work on the unconcat merge file too.

# If the TPM file does not have read data in grouped order, parse a metadata file to correct this

import sys
import pandas
import seaborn as sns
import numpy

read_file = sys.argv[1]
out_file = sys.argv[2]

if len(sys.argv) > 3:
    metadata_file = sys.argv[3]
    print('using metadata file to correct read file order')
    metadata_df = pandas.read_csv(metadata_file, delim_whitespace=True)
    runs = metadata_df['SRA_accession'].tolist()
    cols=[]
    for i in runs:
        cols.append(i+'_TPM')
    read_df = pandas.read_csv(read_file, delim_whitespace = True)

else:
    with open(read_file) as f:
        headings = f.readline()
        headings = headings.rstrip().rsplit()

    read_df = pandas.read_csv(read_file, delim_whitespace = True)

    cols = []
    for col in read_df.columns:
        if 'Name' in col or 'Length' in col or 'EffectiveLength' in col:
            continue
        else:
            cols.append(col)

TPM_df = pandas.DataFrame(read_df, columns = cols)
corr = TPM_df.corr(method='spearman')

# if (corr.min()).min() < 0.5:
#     min, max, middle = 0, 1, 0.5
# else:
#     min, max, middle = 0.5, 1, 0.75
#
print('boop')

#min, max, middle = (corr.min()).min(), 1, 1-((1-(corr.min()).min())/2)

if (corr.min()).min() < 0.5:
    min, max, middle = (corr.min()).min(), 1, 1-((1-(corr.min()).min())/2)
else:
    min, max, middle = 0.5, 1, 0.75

ax = sns.heatmap(
    corr,
    vmin = min, vmax = max, center = middle,
    cmap=sns.color_palette("Reds", n_colors=100),
    square=True,
    xticklabels=True,
    yticklabels=True
)

ax.set_xticklabels(
    ax.get_xticklabels(),
    rotation=45,
    horizontalalignment='right',
    fontsize=5
);

ax.set_yticklabels(
    ax.get_yticklabels(),
    fontsize=5
);

fig = ax.get_figure()
fig.tight_layout()
fig.savefig(out_file)
