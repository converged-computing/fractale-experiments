#!/bin/bash

# WARNING: The original Slurm script contained conflicting resource requests
# (-n40, -N16, --ntasks-per-node=40). The following directives are a best-effort
# interpretation, assuming the user intended to run 1 task on each of the 16 nodes,
# with each task using 40 cores for OpenMP threading.

#FLUX: --nodes=16
#FLUX: --ntasks=16
#FLUX: --cores-per-task=40
# The -p general (partition) directive is ignored as per instructions.
#FLUX: --time-limit=24h

ulimit -s unlimited
module load gcc/5.4.0
module load openmpi/1.10.3-gcc_5.4.0
module load cmake
module load mkl

source /projects/opt/intel/parallel_studio_xe_2016/mkl/bin/mklvars.sh intel64
export OMP_NUM_THREADS=40
export KMP_STACKSIZE=3200M


## Copy files to work directory:
#cp $SUBMITDIR/YourDatafile $SCRATCH

## Mark outfiles for automatic copying to $SUBMITDIR:
#chkfile YourOutputfile

## Run command
# NOTE: This will only run the command on the first node of the allocation.
# A parallel launcher like `flux mini run` is needed to run on all nodes.
./run.sh 
