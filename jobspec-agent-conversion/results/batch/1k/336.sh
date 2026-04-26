#!/usr/bin/env bash
#FLUX: --nodes=1
#FLUX: --tasks-per-node=4
#FLUX: --ntasks=4
#FLUX: --time=2h


# define file that contains job array paremeters
PARAMETER_FILE='sample_ids.txt'
BWA_INDEX='path/to/index_base'

# extract Nth line from PARAMETER_FILE and save it as
# the variable named SAMPLE
# NOTE: This script is a job array. The SLURM_ARRAY_TASK_ID variable has been
# replaced with FLUX_JOB_CC. You must submit this job with a --cc flag.
SAMPLE=$(sed -n ${FLUX_JOB_CC}p ${PARAMETER_FILE})

# Define fastq file names based on this SAMPLE variable
FASTQ_1="data/${SAMPLE}_R1_001.fastq.gz"
FASTQ_2="data/${SAMPLE}_R2_001.fastq.gz"

# Do whatever needs to be done with your inputs
module load bwa
bwa mem ${BWA_INDEX} $ ${FASTQ_1} ${FASTQ_2} > ${SAMPLE}.sam
