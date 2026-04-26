#!/bin/bash
# The -p long (partition), --mail-type, and --mail-user directives are ignored as per instructions.
#FLUX: --job-name=HEPG2_rna_seq
#FLUX: --nodes=1
#FLUX: --ntasks=1
# The --mem=6gb directive has no direct flux analog and is omitted.
#FLUX: --time-limit=20h
#FLUX: --output=nextflow.out
#FLUX: --error=nextflow.err

pwd; hostname; date

# The SLURM_CPUS_ON_NODE variable is replaced with FLUX_JOB_NCORES.
echo "Here we go You've requested $FLUX_JOB_NCORES core."

module load singularity/3.1.1

# CRITICAL: This nextflow command may use a Slurm-specific configuration.
# The profile and config files may need to be updated for Flux.
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
