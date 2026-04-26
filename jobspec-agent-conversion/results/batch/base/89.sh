#!/bin/bash
#FLUX: --nodes=1
#FLUX: --tasks-per-node=4
#FLUX: --cores-per-task=7
#FLUX: --time-limit=24h
#FLUX: --gpus-per-node=4

# The SLURM --mem directive was commented out and has been omitted.
# The SLURM --ntasks-per-socket directive has no direct Flux analog.
# The SLURM mail directives have no direct Flux analog.

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
    # CRITICAL: The dependency format 'afterany:$SLURM_JOB_ID' is Slurm-specific.
    # This must be replaced with a valid Flux RFC 26 dependency URI.
    flux submit --dependency=afterany:$FLUX_JOB_ID run.sample.qs
    # run NPT sampling
    flux mini run -n 4 /home/tgartner/Software-deepmd-kit-1.0/lammps-3Mar20/src/lmp_mpi -i in.lammps.sample -e screen
else
    echo "There is an error"
fi
