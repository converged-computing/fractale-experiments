#!/bin/bash -l
#FLUX: --nodes=6
#FLUX: --ntasks=96
#FLUX: --time-limit=30m

source /ssoft/spack/bin/slmodules.sh -r stable 

module purge
module load gcc/5.3.0 mvapich2/2.2b openblas/0.2.18 cp2k/3.0-mpi
export OMP_NUM_THREADS=1

date_start=$(date +%s)

# The slurm 'srun' command is replaced by 'flux run'.
# The number of tasks is taken from the job directives.
flux run cp2k.popt -i *.inp -o output.out
date_end=$(date +%s)
time_run=$((date_end-date_start))
echo "096_cpus $time_run seconds"

rm -f GTH_BASIS_SETS POTENTIAL *xyz *restart          #remove useless big files (please!) 
