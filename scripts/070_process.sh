#!/bin/bash

mkdir ../070/

# discard sizes

./2_bedtool_discard_sizes.pl ../060/SRR5163632_SRR5163633_SRR5163634_trim_gsnap_piranha_sort_merge_mapGFF_minLen0.bed 50 > ../070/SRR5163632_SRR5163633_SRR5163634_trim_gsnap_piranha_sort_merge_mapGFF_minLen0_max50.bed
./2_bedtool_discard_sizes.pl ../060/SRR5163635_SRR5163636_SRR5163637_trim_gsnap_piranha_sort_merge_mapGFF_minLen0.bed 50 > ../070/SRR5163635_SRR5163636_SRR5163637_trim_gsnap_piranha_sort_merge_mapGFF_minLen0_max50.bed


# cat 
cat ../070/SRR5163632_SRR5163633_SRR5163634_trim_gsnap_piranha_sort_merge_mapGFF_minLen0_max50.bed ../070/SRR5163635_SRR5163636_SRR5163637_trim_gsnap_piranha_sort_merge_mapGFF_minLen0_max
50.bed > ../070/SRR5163632_SRR5163633_SRR5163634_SRR5163635_SRR5163636_SRR5163637_trim_gsnap_piranha_sort_merge_mapGFF_minLen0_max_50_cat.bed

# sort
sort -k1,1 -k2,2n ../070/SRR5163632_SRR5163633_SRR5163634_SRR5163635_SRR5163636_SRR5163637_trim_gsnap_piranha_sort_merge_mapGFF_minLen0_max_50_cat.bed > ../070/SRR5163632_SRR5163633_SRR5163634_SRR5163635_SRR5163636_SRR5163637_trim_gsnap_piranha_sort_merge_mapGFF_minLen0_max_50_cat_sort.bed

# merge
bedtools merge -s -c 4,5,6 -o distinct -i ../070/SRR5163632_SRR5163633_SRR5163634_SRR5163635_SRR5163636_SRR5163637_trim_gsnap_piranha_sort_merge_mapGFF_minLen0_max_50_cat_sort.bed > ../070/SRR5163632_SRR5163633_SRR5163634_SRR5163635_SRR5163636_SRR5163637_trim_gsnap_piranha_sort_merge_mapGFF_minLen0_max_50_cat_sort_merge.bed


############################### 

zcat ../data/AAE/GCF_000004015.4_AaegL3_genomic.fna.gz > ../060/../data/AAE/GCF_000004015.4_AaegL3_genomic.fna
#get fasta
bedtools getfasta -s -name -fi ../060/GCF_000004015.4_AaegL3_genomic.fna -bed ../070/SRR5163632_SRR5163633_SRR5163634_SRR5163635_SRR5163636_SRR5163637_trim_gsnap_piranha_sort_merge_mapGFF_minLen0_max_50_cat_sort_merge.bed -fo ../060/SRR5163632_SRR5163633_SRR5163634_SRR5163635_SRR5163636_SRR5163637_trim_gsnap_piranha_sort_merge_mapGFF_minLen0_max_50_cat_sort_merge.fa

# upper case
./3_fasta_uc.pl ../060/SRR5163632_SRR5163633_SRR5163634_SRR5163635_SRR5163636_SRR5163637_trim_gsnap_piranha_sort_merge_mapGFF_minLen0_max_50_cat_sort_merge.fa > ../060/SRR5163632_SRR5163633_SRR5163634_SRR5163635_SRR5163636_SRR5163637_trim_gsnap_piranha_sort_merge_mapGFF_minLen0_max_50_cat_sort_merge_UC.fa

