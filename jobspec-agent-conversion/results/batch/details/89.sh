#!/bin/bash
#FLUX: --nodes=1
#FLUX: --ntasks=4
# The --ntasks-per-socket=2 directive has no direct flux analog and is omitted.
#FLUX: --cores-per-task=7
#FLUX: --time-limit=24h
# The --mem=32G directive was commented out and is ignored.
#FLUX: --gpus-per-task=1
# The --mail directives are ignored as per instructions.

# load environment
module load cudatoolkit/10.0
module load cudnn/cuda-10.0/7.6.3
module load openmpi/gcc/3.1.3/64
#module load fftw
source /home/tgartner/Software-deepmd-kit-1.0/tensorflow-venv/bin/activate
module load /home/tgartner/modulefiles/plumed-tg
# export OMP_NUM_THREADS=1

if [ -f "Sampledone.txt" ]; then
    echo "Simulation finished"
elif ! grep -q 'ERROR' slurm*; then
    echo "Continuing NPT sampling"
    # The sbatch dependency is replaced with the flux equivalent.
    # SLURM_JOB_ID is replaced with FLUX_JOB_ID.
    flux submit --dependency=afterany:$FLUX_JOB_ID run.sample.qs
    # run NPT sampling
    # The mpirun command is replaced with `flux mini run`
    flux mini run /home/tgartner/Software-deepmd-kit-1.0/lammps-3Mar20/src/lmp_mpi -i in.lammps.sample -e screen
else
    echo "There is an error"
fi
