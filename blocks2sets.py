"""
In the blocks and the panel:
- rows are Haplotypes
- columns are SNPs

1. group SNPs with value=1 in the panel using the same set of haplotypes (rows)
2. group haplotypes by SNPs 
"""
import sys
import json 
from tqdm import tqdm

from collections import defaultdict

# python blocks2sets.py <path_output> <path_panel.txt> <path_blocks.txt>

path_blocks = sys.argv[-1]
path_panel  = sys.argv[-2]
path_output = sys.argv[-3]

with open(path_panel, "r") as fp:
    lines = fp.readlines()

block_by_K = dict()
with open(path_blocks, "r") as fp:
    blocks = fp.readlines()

# 1. join blocks sharing the same set of rows (only columns with 1)    
pbar = tqdm(total=len(blocks))
blocks_sharing_K = defaultdict(list) # haplotypes: snps
for j, b in enumerate(blocks): 
    K, start, end = eval(b.replace("\n",""))
    K.sort()

    # add columns where the string in the block is a 1 (cols are SNPs)
    cols = [col+start for col, char in enumerate(lines[K[0]][start:end+1]) if char == "1"] # this is to filter only presence

    blocks_sharing_K[tuple(K)].extend(cols)
    pbar.update(1)
pbar.close()
 
# 2. set of snps being used by the same set of haplotypes
snps2hap = defaultdict(list)
for hap, snps in blocks_sharing_K.items():
    if len(snps) > 0: 
        snps.sort()
        snps2hap[tuple(snps)].extend(
            hap
        )

# save set of snps and haplotypes that are maximal (same string)  
with open(path_output,"w") as fp:
    for snps, hap in snps2hap.items():
        snps=list(snps)
        snps.sort()
        haplotypes=list(set(hap))
        haplotypes.sort()

        # string of indexes
        snps = ",".join([str(s) for s in snps])
        haplotypes = ",".join([str(s) for s in haplotypes])

        # save info
        fp.write(f"{snps}\t{haplotypes}\n")
