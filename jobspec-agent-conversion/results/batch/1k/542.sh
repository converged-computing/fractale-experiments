#!/bin/sh
#FLUX: --job-name=Ni_rose
#FLUX: --ntasks=128
#FLUX: --cores-per-task=1
#FLUX: --time-limit=1d
#FLUX: --output=job.out
#FLUX: --error=job.err



# NOTE: The --distribution=cyclic:cyclic and --mem-per-cpu flags are not supported.

pwd; hostname; date
 
module load intel/2018.1.163 
module load openmpi/3.0.0

OMPI_MCA_mpi_warn_on_fork=0
export OMPI_MCA_mpi_warn_on_fork

echo PYTHONPATH=$PYTHONPATH
echo python=$(which python)
echo PATH=$PATH

echo "start_time:$(date)"
# 'srun' is replaced with 'flux run'
flux run -n 128 python mc_iterative_sampler.py
# mpirun --mca mpi_warn_on_fork 0
echo "end_time:$(date)"
