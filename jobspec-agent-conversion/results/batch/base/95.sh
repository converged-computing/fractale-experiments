#!/bin/bash
#FLUX: --queue=RM
#FLUX: --time-limit=48h
#FLUX: --nodes=8
#FLUX: --tasks-per-node=26
#FLUX: --bank=phy210030p
#FLUX: --output=/ocean/projects/phy210030p/akshay2/Slurm_logs/multi_acceljerk_{id}.log

# The --mail-type and --mail-user parameters from slurm have no direct equivalent in flux-submit.


# Ensure that the output directory to SBATCH exists prior to batch script execution.
module load openmpi/3.1.6-gcc8.3.1

# Define environment variables. $PROJECT = /ocean/projects/<group id>/<username>
CMDDIR=$PROJECT/HPC_pulsar/cmd_files

echo $FLUX_NTASKS
# Run acceleration searches within singularity container.
$CMDDIR/multinode_accelsearch.cmd
