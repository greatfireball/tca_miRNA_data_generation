#!/bin/bash
mkdir -p data/041_miRDeep_completed_with_novels/ || exit 1 

./041_curated_mirdeep2fasta.pl -csv data/012_miRDeep2_output_bwt1/result-bwt1.csv -cutoff 10 || exit 1

# create miRNA mature dataset : miRBase + missing mature arms + novels
mv data/012_miRDeep2_output_bwt1/result-bwt1-mature.fa data/041_miRDeep_completed_with_novels/ || exit 1
cat data/021_completed_mature_miRBase/tca_mature_mirbase_completed.fa data/041_miRDeep_completed_with_novels/result-bwt1-mature.fa > data/041_miRDeep_completed_with_novels/tca_mature_mirbase_completed_novel.fa || exit 1
# create miRNA precursir dataset: miRBase + novels
mv data/012_miRDeep2_output_bwt1/result-bwt1-hairpin.fa data/041_miRDeep_completed_with_novels/ || exit 1
cat db/tca_precursor_mirbase.fa  data/041_miRDeep_completed_with_novels/result-bwt1-hairpin.fa > data/041_miRDeep_completed_with_novels/tca_precursor_mirbase_completed_novel.fa || exit 1