#!/bin/bash -l
#FLUX: --job-name=ITIPAE_clean
#FLUX: --nodes=1
#FLUX: --cores=32
#FLUX: --ntasks=32
#FLUX: --time-limit=2d2h


# NOTE: Memory, rerunnable, join I/O, and -V flags are not supported.

filename="ITIPAE_clean"

#export LAM='/home/yue/lammps-2Aug2023/src/lmp_mpi'

module load lammps/2Aug2023
# cd $PBS_O_WORKDIR # This is the default behavior in Flux
export OMP_NUM_THREADS=1

# 'mpirun' is replaced with 'flux run'
flux run -n 32 lmp_mpi -in in.${filename} > log.${filename} 1>SCREEN.txt 2>&1


### Automatically analyze the results
environment="lammps"
scriptname="readMeanVol"

module load miniconda
bash
. ~/.bashrc

echo "********************************************"
echo "Input file is ${filename} Running, Output file is ${filename}.out"
conda activate $environment
python3 ${scriptname}.py > ${scriptname}.out
echo "********************************************"

mkdir dump
mv *log* dump
mv *.txt dump
mv *.out dump
mkdir input 
mv data.* in.* input
