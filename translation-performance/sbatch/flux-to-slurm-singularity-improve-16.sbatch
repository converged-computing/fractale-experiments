#!/bin/bash
#SBATCH --job-name=amg
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=64
#SBATCH --output=amg-%j.out
#SBATCH --error=amg-%j.err

# --exclusive: This is a performance improvement to ensure that the job has dedicated
# access to the nodes, preventing other jobs from interfering and causing performance jitter.
#SBATCH --exclusive

# --cpu-bind=cores: This is analogous to flux's 'cpu-affinity=per-task' and is a performance
# improvement that binds each task to a specific CPU core. This can improve performance by
# increasing cache efficiency and reducing context switching.
#SBATCH --cpu-bind=cores

# Load the required modules for OpenMPI and AWS EFA networking support.
module load openmpi
module load libfabric-aws

echo "Start time:" $( date +%s )

# The mpirun command launches the parallel application.
# -np 128: Specifies the total number of MPI processes.
# --bind-to core: An OpenMPI flag that pins each MPI process to a physical CPU core.
# -npernode 64: Explicitly tells OpenMPI how many processes to launch on each node.
# The rest of the command executes the amg application within the specified Singularity container.
mpirun -np 128 --bind-to core -npernode 64 \
/shared/apps/bin/singularity exec \
/shared/apps/containers/fractale-agent-experiments_amg2023.sif \
amg -problem 2 -n 90 90 90 -P 4 8 4

echo "End time:" $( date +%s )