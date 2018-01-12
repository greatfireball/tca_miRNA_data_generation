#!/bin/bash

makeblastdb -in db/GCF_000002335.3_Tcas5.2_genomic.fna -dbtype nucl

mkdir -p data/080_miRNA_pos/

#./081_blast_qcov.pl -p blastn -query db/tca_precursor_mirbase_completed_novel.fa -db db/GCF_000002335.3_Tcas5.2_genomic.fna -out data/080_miRNA_pos/ -num_threads 100

blastn -query data/041_miRDeep_completed_with_novels/tca_precursor_mirbase_completed_novel.fa -db db/GCF_000002335.3_Tcas5.2_genomic.fna -out data/080_miRNA_pos/precursor_vs_TCA5_2.blastout -num_threads 100 -outfmt "6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore qcovs"

awk '$3 >= 100 && $13' data/080_miRNA_pos/precursor_vs_TCA5_2.blastout > data/080_miRNA_pos/precursor_vs_TCA5_2_100_100.blastout

