#!/bin/bash
#FLUX: -q long
#FLUX: --job-name=HEPG2_rna_seq
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: -t 20h
#FLUX: --output=nextflow.out
#FLUX: --error=nextflow.err

# NOTE: The Slurm directive '--mem=6gb' was omitted as there is no direct Flux equivalent.
# This may cause the job to fail if scheduled on a node with insufficient memory.
# NOTE: The Slurm directives for email notification ('--mail-type' and '--mail-user') were omitted as there are no direct Flux equivalents.

pwd; hostname; date
echo "Here we go You've requested $FLUX_NTASKS task."

module load singularity/3.1.1

nextflow run nf-core/rnaseq -r 1.4.2 \
-resume \
-profile singularity \
--reads '/scratch/Shares/rinnclass/CLASS_2022/JR/CLASS_2022/class_exeRcises/analysis/17_API_RNASEQ/fastq/*{_read1,_read2}.fastq.gz' \
--fasta /scratch/Shares/rinnclass/CLASS_2022/data/genomes/GRCh38.p13.genome.fa \
--gtf /scratch/Shares/rinnclass/CLASS_2022/data/gencode.v32.annotation.gtf \
--pseudo_aligner salmon \
--gencode \
--email john.rinn@colorado.edu \
-c nextflow.config

date

