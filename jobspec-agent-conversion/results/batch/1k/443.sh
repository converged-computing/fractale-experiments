#!/bin/bash
#FLUX: --nodes=1
#FLUX: --tasks-per-node=4
#FLUX: --cores-per-task=7
#FLUX: --time-limit=24h
#FLUX: --gpus-per-node=4
#FLUX: --job-name="s-270-3000"

# load environment
module purge
module load cudatoolkit/10.0
module load cudnn/cuda-10.0/7.6.3
module load openmpi/gcc/3.1.3/64

LAMMPS_EXE=/home/ppiaggi/Programs/Software-deepmd-kit-1.0/lammps-git2/src/lmp_mpi
source /home/ppiaggi/Programs/Software-deepmd-kit-1.0/tensorflow-venv/bin/activate

# run NPT sampling
flux mini run -n 4 $LAMMPS_EXE -i in.lammps.sample

if [ -f "Sampledone.txt" ]; then
    echo "Simulation finished"
elif ! grep -q 'ERROR' slurm*; then
    echo "Continuing NPT sampling"
    flux submit --dependency=afterok:$FLUX_JOB_ID run.sample.qs
else
    echo "There is an error"
fi
