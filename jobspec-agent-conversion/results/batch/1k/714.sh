#!/bin/bash
#FLUX: --nodes=1
#FLUX: --cores=40
#FLUX: --time-limit=45h
#FLUX: --job-name=csl_benchmark
#FLUX: --output=csl_benchmark.out
#FLUX: --error=csl_benchmark.out

echo -n "this script is running on: "
hostname -f
date

#export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}"

# since openmpi is compiled with PBS(Torque) support there is no need to
# specify the number of processes or a hostfile to mpirun.
cd /home/kronbichler/sw/denis/large-strain-matrix-free/Calculations

module load gcc/9 mpi/openmpi-4.0.1

python pre_process.py --likwid --dir=CSL_Munich --prefix=/home/kronbichler/sw/denis/large-strain-matrix-free/build_avx512/ --calc=/home/kronbichler/sw/denis/large-strain-matrix-free/Calculations/

flux mini run -n 40 bash likwid_run.sh 
