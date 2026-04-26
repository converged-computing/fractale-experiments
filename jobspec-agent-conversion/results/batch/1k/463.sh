#!/bin/bash
# The -p, -A, --mail-type, and --mail-user directives are ignored as per instructions.
#FLUX: --time-limit=48h
#FLUX: --nodes=8
#FLUX: --tasks-per-node=26
#FLUX: --output=/ocean/projects/phy210030p/akshay2/Slurm_logs/multi_acceljerk_%j.log

# Ensure that the output directory to SBATCH exists prior to batch script execution.
module load openmpi/3.1.6-gcc8.3.1

# Define environment variables. $PROJECT = /ocean/projects/<group id>/<username>
CMDDIR=$PROJECT/HPC_pulsar/cmd_files

# The SLURM_NTASKS variable is replaced with FLUX_JOB_NTASKS
echo $FLUX_JOB_NTASKS
# Run acceleration searches within singularity container.
$CMDDIR/multinode_accelsearch.cmd
