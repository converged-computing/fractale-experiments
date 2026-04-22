#!/bin/bash
#
#SBATCH --nodes=2                   # -N2 from flux: Request 2 nodes
#SBATCH --ntasks=128                # -n 128 from flux: Request 128 tasks in total

# Performance Tuning & Best Practices
#SBATCH --job-name=lammps_reaxff    # Best practice: Give the job a descriptive name
#SBATCH --ntasks-per-node=64        # Performance: Explicitly set tasks per node for better resource allocation by Slurm.
#SBATCH --exclusive                 # Performance: Request exclusive access to the nodes to prevent interference from other jobs.
#SBATCH --distribution=cyclic:cyclic # Performance: Distribute tasks cyclically across nodes and sockets, which can improve performance for communication-heavy applications.

# Standard Output and Error files
#SBATCH --output=lammps_reaxff_%j.out
#SBATCH --error=lammps_reaxff_%j.err

# Setup the environment
echo "Loading modules..."
module load openmpi
module load libfabric-aws

# Start timing
echo "Start time:" $( date +%s )

# Execute the application using mpirun and Singularity
# mpirun handles the parallel execution across the allocated resources.
# singularity exec runs the command inside the specified container.
# The --pwd flag sets the working directory inside the container to where the application data is.
mpirun singularity exec --pwd /opt/lammps-reax /shared/apps/containers/fractale-agent-experiments_lammps-reax.sif lmp -v x 20 -v y 20 -v z 20 -in in.reaxff.hns

# End timing
echo "End time:" $( date +%s )