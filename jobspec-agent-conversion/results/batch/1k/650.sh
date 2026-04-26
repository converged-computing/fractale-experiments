#!/bin/bash

#FLUX: --ntasks=9
#FLUX: --nodes=3
#FLUX: --tasks-per-node=3
#FLUX: --job-name=MPICC
#FLUX: --output=stdout_%J.txt
#FLUX: --error=stderr_%J.txt

export OMP_NUM_THREADS=1
# valid values: hash, ds12, ds21
export PMIX_MCA_gds=hash
# valid values: cma, emulated, none
export OMPI_MCA_btl_vader_single_copy_mechanism=none

# 'srun' is replaced by 'flux run' for launching MPI jobs in Flux
flux run -n 9 apptainer exec mpicc.sif mpi-pi
