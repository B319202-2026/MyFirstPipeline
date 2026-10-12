#!/bin/bash

DATA_DIR="/localdisk/data/BPSM/MyFirstPipeline"
FASTQ_DIR="$DATA_DIR/fastq"
SAMPLE_FILE="$FASTQ_DIR/Tco2.fqfiles"
GENOME_DIR="$DATA_DIR/Tcongo_genome"
GENOME_FASTA="$GENOME_DIR/TriTrypDB-46_TcongolenseIL3000_2019_Genome.fasta.gz"
BED_FILE="$DATA_DIR/TriTrypDB-46_TcongolenseIL3000_2019.bed"

mkdir -p results/fastqc
mkdir -p results/bam
mkdir -p results/counts

echo "===== Running FastQC ====="

for file in $FASTQ_DIR/*.fq.gz
do
    fastqc $file -o results/fastqc
done

echo "FastQC complete."


# Task2
echo "Summarizing QC data"

SUMMARY_FILE="results/fastqc_summary.txt"
echo -e "Sample\tTotal_Sequences" > $SUMMARY_FILE

for zip_file in results/fastqc/*_fastqc.zip
do
    sample_name=$(basename $zip_file _fastqc.zip)

    total_seq=$(unzip -p $zip_file */fastqc_data.txt | grep "^Total Sequences" | awk '{print $3}')

    echo -e "$sample_name\t$total_seq" >> $SUMMARY_FILE
done

echo "QC Summary saved to $SUMMARY_FILE"
