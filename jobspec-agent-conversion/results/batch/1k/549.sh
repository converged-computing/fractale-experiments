#!/usr/bin/env zsh
#
#### Job name
#FLUX: --job-name=preprocessing
#FLUX: --error=./preprocessing.txt
#FLUX: --output=./preprocessing.txt
#FLUX: --time-limit=5d
#FLUX: --ntasks=1
#FLUX: --cores-per-task=48


source ~/.zshrc
conda activate nf-core-atacseq-1.2.1

# downloading of SRA
prefetch -v SRR3689759
prefetch -v SRR3689760
prefetch -v SRR3689933	
prefetch -v SRR3689934	

# dump each read into separate file. Files will receive suffix corresponding to read number.
fastq-dump --split-files --gzip /hpcwork/izkf/ncbi/sra/SRR3689759.sra
fastq-dump --split-files --gzip /hpcwork/izkf/ncbi/sra/SRR3689760.sra
fastq-dump --split-files --gzip /hpcwork/izkf/ncbi/sra/SRR3689933.sra
fastq-dump --split-files --gzip /hpcwork/izkf/ncbi/sra/SRR3689934.sra

# run nf-core/atac pipeline
/home/rs619065/miniconda3/bin/nextflow run nf-core/atacseq --input design.csv --genome hg38 --narrow_peak 
