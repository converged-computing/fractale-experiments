#!/bin/bash
#FLUX: --job-name="rfm_PismTest1_pism_1_1_4__gcc__cijv4kn___nodes___1___mpi___64___omp___1__job"
#FLUX: --ntasks=64
#FLUX: --tasks-per-node=64
#FLUX: --nodes=1
#FLUX: --cores-per-task=1
#FLUX: --output=rfm_PismTest1_pism_1_1_4__gcc__cijv4kn___nodes___1___mpi___64___omp___1__job.out
#FLUX: --error=rfm_PismTest1_pism_1_1_4__gcc__cijv4kn___nodes___1___mpi___64___omp___1__job.err
# The -p c6gn (partition) directive is ignored as per instructions.
#FLUX: --exclusive

spack load pism@1.1.4 %gcc /cijv4kn
export OMP_NUM_THREADS=1
export OMP_PLACES=cores
# The srun command is replaced by `flux mini run`
flux mini run /usr/bin/time -f "real:%e" pismv -test B -Mx 61 -Mz 11 -ys 422.45 -y 25000 &> pismv.out
