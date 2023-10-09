#!/bin/bash

PATH_WILD_PBWT=../pangeblocks/Wild-pBWT/bin/wild-pbwt

PATH_CSV=/home/avila/PEPS-data/test.csv
PATH_PANEL=panel-$(basename $PATH_CSV).txt
PATH_BLOCKS=blocks-$(basename $PATH_CSV).txt
PATH_OUTPUT=sites_haplotypes-$(basename $PATH_CSV).txt
echo $PATH_PANEL
echo $PATH_BLOCKS
echo $PATH_OUTPUT

# create panel
python csv2panel.py $PATH_CSV $PATH_PANEL

# compute maximal blocks
$PATH_WILD_PBWT -a 2 -f $PATH_PANEL -b 2 -o y > $PATH_BLOCKS

# get sets of SNPs that are used by the same set of haplotypes
python blocks2sets.py $PATH_OUTPUT $PATH_PANEL $PATH_BLOCKS