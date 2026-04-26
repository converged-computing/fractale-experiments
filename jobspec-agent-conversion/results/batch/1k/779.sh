#!/bin/bash
#FLUX: --job-name=1_thread
#FLUX: --nodes=1
#FLUX: --ntasks=40
#FLUX: --gpus-per-node=1
#FLUX: --time-limit=1d
#FLUX: --output=DNMT3a-%j.out
#FLUX: --error=DNMT3a-%j.err


source /etc/profile.d/modules.sh
module load centos7.3/app/gromacs/2020-impi-mkl-PS2018-GOLD-CUDA
module load  centos7.3/lib/cuda/10.0

module load centos7.3/lib/openmpi/1.8.8-gcc-4.8.5
module load centos7.3/lib/acml/6.1.0-gfortan64

export OMP_NUM_THREADS=1
# NOTE: Slurm-specific environment variables are not available in Flux.
# echo "SLURM_NODELIST $SLURM_NODELIST"
# echo "NUMBER OF CORES $SLURM_NTASKS"

# The MPI application is launched with 'flux run'
flux run -n 40 $GROMACS_DIR/bin/gmx_mpi mdrun -v -deffnm complex_md -pin on
exit
