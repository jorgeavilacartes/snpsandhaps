DICT_CODES = {"0":"0", "1":"1", "2":"1"} # keys will be mapped to the values when creating the panel

# python csv2panel.py <path_csv.csv> <path_panel.txt>

import pandas as pd
from pathlib import Path

import sys
path_csv = sys.argv[-2]
path_panel = sys.argv[-1]

transpose = True # if True, haplotypes are rows / SNPs are columns

df = pd.read_csv(path_csv, index_col=0)
nrows, ncols = df.shape
if not transpose: 
    print(f"keeping original panel size [nrows,ncols]=[{nrows},{ncols}]")   
    numpy = df.to_numpy()
else:
    print(f"Transposing panel to [nrows,ncols]=[{ncols},{nrows}]")
    numpy = df.to_numpy().transpose()

with open(path_panel, "w") as fp:

    for row in range(numpy.shape[0]):
        row_panel = "".join(DICT_CODES[str(e)] for e in numpy[row])
        fp.write(row_panel + "\n")       