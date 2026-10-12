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
