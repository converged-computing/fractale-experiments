#!/bin/bash
#SBATCH --job-name=lammps_reaxff
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=64
#SBATCH --output=lammps_output_%j.log
#SBATCH --error=lammps_error_%j.log

# Performance Enhancement: Bind each task to a specific CPU core.
# This prevents the operating system from migrating tasks between cores, which
# improves cache utilization and overall performance. This is a more explicit
# and robust way to achieve the goal of Flux's '--cpu-affinity=per-task'.
#SBATCH --cpu-bind=cores

# Performance Enhancement: Request exclusive access to the node.
# This ensures no other jobs run on the node, guaranteeing all resources
# (memory bandwidth, network, etc.) are available to this job.
#SBATCH --exclusive

# Load modules required for OpenMPI and high-performance networking on AWS (EFA)
module load openmpi
module load libfabric-aws

echo "Start time:" $( date +%s )

# Run the LAMMPS command within a Singularity container.
# mpirun is used to launch the parallel application, and Slurm's process
# manager will automatically provide it with the correct number of tasks and hosts.
# The '--pwd' flag sets the working directory inside the container to where the input data is located.
mpirun /shared/apps/bin/singularity exec --pwd /opt/lammps-reax /shared/apps/containers/fractale-agent-experiments_lammps-reax.sif lmp -v x 20 -v y 20 -v z 20 -in in.reaxff.hns

echo "End time:" $( date +%s )