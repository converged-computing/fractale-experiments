#!/bin/sh

#FLUX: --job-name=SIMPA
#FLUX: --time-limit=1h30m
#FLUX: --error=./%A.err
#FLUX: --output=./%A.out
#FLUX: --nodes=4
#FLUX: --ntasks=160


# load an installed Open MPI
module load mpi/OpenMPI/3.1.4-GCC-8.3.0

# running the example provided in the repositiory
# 'srun' is replaced with 'flux run'
flux run -n 160 python SIMPA.py --bed ./scExamples/H3K4me3_hg38_5kb/BC8791969.bed --targets H3K4me3
