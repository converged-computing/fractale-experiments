#!/bin/bash
#FLUX: --job-name=test_mpi_dask
#FLUX: --nodes=1
#FLUX: --ntasks=10
#FLUX: --cores-per-task=4
#FLUX: --time-limit=20m
#FLUX: --output=output_dask_SVG.out
#FLUX: --error=error_dask_SVG.out

# The PBS memory request (-l mem=40GB) has no direct analog in the provided flux submit options.
# This may impact job scheduling and resource allocation.
# The original script requested 20 mpiprocs but launched 10; this conversion uses ntasks=10 to match the launch command.

module load chpc/cuda/11.2/SXM2/11.2 chpc/openmpi/4.0.0/gcc-7.3.0 chpc/openblas/0.2.19/gcc-6.1.0 chpc/astro/anaconda/3
source /home/sdigioia/.bashrc
conda activate py310

# Qsub template for initializing a Dask cluster with dask-mpi
# Scheduler: PBS

#rm -f scheduler.json
python SVCclassifier_dask.py > output_SVC_dask.txt 

python SVCclassifier_scipy.py > output_SVC_scipy.txt
