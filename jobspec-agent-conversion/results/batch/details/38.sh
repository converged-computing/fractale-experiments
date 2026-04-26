#!/bin/bash

#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=1
#FLUX: --gpus-per-task=1
# The --mem=40GB directive has no direct flux analog and is omitted.
#FLUX: --time-limit=12h
#FLUX: --job-name=2Lsim

module purge

export NUM_JULIA_THREADS=`nproc`

# The SLURM_JOB_ID variable is replaced by FLUX_JOB_ID
rundir=$SCRATCH/twolayer_simulation/$FLUX_JOB_ID
mkdir -p $rundir
cp TwoLayerSimulation.jl Driver.jl driver.sbatch $rundir
cp Parameters.jl $rundir/Parameters.jl
cd $rundir

# The SLURM_CPUS_PER_TASK variable is replaced with FLUX_JOB_NCORES
julia -t $FLUX_JOB_NCORES Driver.jl > run.log

exit
