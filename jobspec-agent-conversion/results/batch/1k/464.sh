#!/bin/bash
#FLUX: --time-limit=30h
#FLUX: --nodes=1
#FLUX: --tasks-per-node=22
#FLUX: --output=/ocean/projects/phy210030p/akshay2/Slurm_logs/prepsubband_slurm_{id}.log

# Ensure that the output directory to SBATCH exists prior to batch script execution.

# Define environment variables. $PROJECT = /ocean/projects/<group id>/<username>
SINGULARITY_CONT=$PROJECT/psrsearch.sif
CMDDIR=$PROJECT/HPC_pulsar/cmd_files

# Run dedispersion module within singularity container.
singularity exec -B /local $SINGULARITY_CONT $CMDDIR/dedispersion.cmd
