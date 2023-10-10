### create environment to run snakemake 
```bash
micromamba env create -n snakemake -f envs/snakemake.yml
micromamba activate snakemake
```

run pipeline, set parameters in `params.yml`
```bash
snakemake -s computesets.smk -c 16 --use-conda
```

### what the pipeline does.

Given an haplotype panel in the format of the one in `data/test.csv` with SNPs as rows, and Haplotypes as columns,
return a plain text file with two columns (separated by "\t"):
- column1: set of SNPs (indexes) split by ","
- column2: set of Haplotypes (indexes) split by ","
the pairs of sets (SNPs, Haplotypes) in each row correspond to a group of haplotypes where all of them uses the set of SNPs (=1).


How these pairs of sets are computed:

1. Create panel to feed Wild-PBWT (the panel will be transposed since SNPs sites tend to be larger): [Haplotypes, SNPs]
2. Compute maximal blocks in the panel: sets $(K,b,e)$, where $K$ is a set of haplotypes, and $[b,e]$ an interval of columns of SNPs where all rows in $K$ have the same string in between the columns $[b,e]$
3. Compute sets (SNPs, Haplotypes): 
    - blocks are joined if they share the set $K$
    - columns of all blocks sharing the same $K$ are joined, but we only keep columns that have a 1 in the block
    - now to find all haplotypes using a set of SNPs, we do the union of sets $K$ sharing the same columns, to finally obtain pairs of sets (SNPS, Haplotypes).