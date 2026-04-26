#!/bin/bash
#FLUX: --nodes=1
#FLUX: --ntasks-per-node=4
#FLUX: --ntasks=4
#FLUX: --cores-per-task=7
#FLUX: --time-limit=23h30m
#FLUX: --gpus-per-node=4
#FLUX: --job-name="i-270-4000"



# load environment
module purge
module load cudatoolkit/10.0
module load cudnn/cuda-10.0/7.6.3
module load openmpi/gcc/3.1.3/64

LAMMPS_EXE=/home/ppiaggi/Programs/Software-deepmd-kit-1.0/lammps-git2/src/lmp_mpi
source /home/ppiaggi/Programs/Software-deepmd-kit-1.0/tensorflow-venv/bin/activate

# run NPT sampling
# 'mpirun' is replaced with 'flux run'
flux run -n 4 $LAMMPS_EXE -i in.lammps.init
rm in.boxdimensions
python BoxDimensions.py > in.boxdimensions
flux run -n 4 $LAMMPS_EXE -i in.lammps.equil

# NOTE: The self-resubmission logic from the original script is not supported in Flux
# and has been removed.
if ! grep -q 'ERROR' slurm*; then
    echo "Continuing equilibration was the original intent, but is not supported here."
else
    echo "There is an error"
fi
