#!/bin/bash
#FLUX: --time-limit=10m
#FLUX: --nodes=2

module load gcc/5.4.0
module load hdf5
module load cuda/8.0.54
module load spectrum-mpi
source $OLCF_SPECTRUM_MPI_ROOT/jsm_pmix/bin/export_smpi_env -gpu
/usr/bin/time -f 'ExE_Time: %e' flux run -n 2 -g 1 -c 1 ./run_2g_weak.sh
/usr/bin/time -f 'ExE_Time: %e' flux run -n 2 -g 1 -c 1 ./run_2g_weak.sh
/usr/bin/time -f 'ExE_Time: %e' flux run -n 2 -g 1 -c 1 ./run_2g_weak.sh
/usr/bin/time -f 'ExE_Time: %e' flux run -n 2 -g 1 -c 1 ./run_2g_weak.sh
/usr/bin/time -f 'ExE_Time: %e' flux run -n 2 -g 1 -c 1 ./run_2g_weak.sh
