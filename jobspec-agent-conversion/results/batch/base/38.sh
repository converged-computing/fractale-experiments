#!/bin/bash

#FLUX: --nodes=1
#FLUX: --tasks-per-node=1
#FLUX: --cores-per-task=1
#FLUX: --gpus-per-node=1
#FLUX: -t 12h
#FLUX: --job-name=2Lsim

# NOTE: The Slurm directive '--mem=40GB' was omitted as there is no direct Flux equivalent.
# This may cause the job to fail if scheduled on a node with insufficient memory.

module purge

export NUM_JULIA_THREADS=`nproc`

# The script now uses the Flux job ID to create the run directory.
rundir=$SCRATCH/twolayer_simulation/$FLUX_JOB_ID
mkdir -p $rundir
cp TwoLayerSimulation.jl Driver.jl driver.sbatch $rundir
cp Parameters.jl $rundir/Parameters.jl
cd $rundir

# The original script used $SLURM_CPUS_PER_TASK. This has been replaced with the
# value requested in the header, as there is no direct Flux environment variable for it.
julia -t 1 Driver.jl > run.log

exit

