#!/bin/bash
#FLUX: --bank=phillipslab
#FLUX: --queue=phillips
#FLUX: --job-name=filt1
#FLUX: --time-limit=4h
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --cc=0-39
#FLUX: --cores-per-task=4

export OMP_NUM_THREADS=4

module load easybuild  icc/2017.1.132-GCC-6.3.0-2.27  impi/2017.1.132 skewer

cd /projects/phillipslab/ateterina/CR_popgen/data/reads/
LISTFILES=(*.fastq)

file=${LISTFILES[$FLUX_JOB_CC]}

#remove adapter + qc
skewer -x AGATCGGAAGAG -t 4 -q 20 -l 36 -d 0.1 -r 0.1 -o ${file/_1.fastq/.tr1} $file ${file/_1.fastq/_2.fastq};


mv ${file/_1.fastq/.tr1-trimmed-pair1.fastq} ${file/_1.fastq/_fp1.ok.fastq}
mv ${file/_1.fastq/.tr1-trimmed-pair2.fastq} ${file/_1.fastq/_fp2.ok.fastq}
