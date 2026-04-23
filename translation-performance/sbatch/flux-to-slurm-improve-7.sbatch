#!/bin/bash
#SBATCH --job-name=lammps_job
# This is a descriptive name for your job.

#SBATCH --nodes=3
# We are requesting 3 nodes, which is a direct translation from the flux -N3 directive.

#SBATCH --ntasks=192
# We are requesting 192 total MPI tasks, which is a direct translation from the flux -n 192 directive.

#SBATCH --exclusive
# This flag ensures that your job gets exclusive access to the nodes.
# This is a performance improvement to prevent other jobs from interfering with your application.

#SBATCH --cpu-bind=cores
# This binds each MPI task to a physical CPU core. It is the Slurm equivalent of flux's `-o cpu-affinity=per-task`
# and is crucial for obtaining good performance for HPC applications.

#SBATCH --hint=nomultithread
# This disables hyper-threading. For many scientific computing applications, this improves performance
# by ensuring each task runs on a dedicated physical core.

# The commands below will be executed on the compute nodes.

echo "Start time:" $( date +%s )

# srun is the Slurm command to launch parallel jobs.
# We add --mpi=pmix as required by the system.
srun --mpi=pmix lmp -v x 20 -v y 20 -v z 20 -in in.reaxff.hns

echo "End time:" $( date +%s )