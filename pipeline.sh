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


#Task3
echo "Aligning reads to genome"

if [ ! -f "Tcongo_index.1.bt2" ]; then
    echo "Building Bowtie2 index..."
    gunzip -c $GENOME_FASTA > Tcongo_genome.fasta
    bowtie2-build Tcongo_genome.fasta Tcongo_index
fi

tail -n +2 $SAMPLE_FILE | while read SampleName SampleType Replicate Time Treatment End1 End2
do
    echo "Processing sample: $SampleName"

bowtie2 -x Tcongo_index \
      -1 $FASTQ_DIR/$End1 \
      -2 $FASTQ_DIR/$End2 \
      | samtools view -bS - | samtools sort -o results/bam/${SampleName}.bam
done

echo "Alignment complete."
