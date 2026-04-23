#!/bin/bash

#SBATCH --job-name=lammps_job
#SBATCH --nodes=4
#SBATCH --ntasks=256
#SBATCH --ntasks-per-node=64

# Performance Tuning Directives
# Request exclusive access to the nodes for performance consistency.
#SBATCH --exclusive

# Distribute tasks cyclically across nodes and sockets. This can improve
# performance for applications sensitive to memory bandwidth by spreading ranks.
#SBATCH --distribution=cyclic:cyclic

# Standard output and error log files
#SBATCH --output=lmp_output_%j.log
#SBATCH --error=lmp_error_%j.log

# Begin execution
echo "Start time:" $( date +%s )

# Launch the parallel job using srun with the required PMIx MPI type.
srun --mpi=pmix lmp -v x 20 -v y 20 -v z 20 -in in.reaxff.hns

# End execution
echo "End time:" $( date +%s )