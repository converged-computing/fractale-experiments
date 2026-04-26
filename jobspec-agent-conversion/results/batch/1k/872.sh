#!/bin/bash

#FLUX: --job-name=porechop_array
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=32
#FLUX: --output=myoutput_%j.out
#FLUX: --error=myerrors_%j.err


# NOTE: The %j format specifier is not supported in Flux; files will be overwritten.

module load openmpi/4.0.3/gcc.8.4.0
export OMP_NUM_THREADS=32

module load anaconda/2020.07
source activate porechop 

WORKDIR=/path/to/read/files

THREAD=32

cd $WORKDIR

# NOTE: This script is a job array. The SLURM_ARRAY_TASK_ID variable has been
# replaced with FLUX_JOB_CC. You must submit this job with 'flux submit --cc=1-12 ...'
SAMPLE_NAME=`ls *_nanopore.fastq.gz | head -n $FLUX_JOB_CC | tail -n 1`
PREFIX=`echo $SAMPLE_NAME | cut -f1 -d'_'` ;
genomeID=$(echo $SAMPLE_NAME)

	porechop -i ${PREFIX}_nanopore.fastq.gz -o ${PREFIX}_output.fastq.gz  --threads ${THREAD}
	
