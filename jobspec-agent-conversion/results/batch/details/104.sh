#!/bin/bash
# The -A (account) and --partition directives are ignored.
#FLUX: --job-name=filt1
#FLUX: --time-limit=4h
#FLUX: --nodes=1
#FLUX: --ntasks=1
# The --array directive is replaced by the --cc flag at submission time.
# This script should be submitted with: flux submit --cc=0-39 your_script_name.sh
#FLUX: --cores-per-task=4

# The SLURM_CPUS_PER_TASK variable is replaced with FLUX_JOB_NCORES
export OMP_NUM_THREADS=$FLUX_JOB_NCORES

module load easybuild  icc/2017.1.132-GCC-6.3.0-2.27  impi/2017.1.132 skewer

cd /projects/phillipslab/ateterina/CR_popgen/data/reads/
LISTFILES=(*.fastq)

# The SLURM_ARRAY_TASK_ID variable is replaced with FLUX_JOB_CC
file=${LISTFILES[$FLUX_JOB_CC]}

#remove adapter + qc
skewer -x AGATCGGAAGAG -t 4 -q 20 -l 36 -d 0.1 -r 0.1 -o ${file/_1.fastq/.tr1} $file ${file/_1.fastq/_2.fastq};


mv ${file/_1.fastq/.tr1-trimmed-pair1.fastq} ${file/_1.fastq/_fp1.ok.fastq}
mv ${file/_1.fastq/.tr1-trimmed-pair2.fastq} ${file/_1.fastq/_fp2.ok.fastq}
