#!/bin/bash
#FLUX: --time-limit=10m
#FLUX: --nodes=8

module load gcc/5.4.0
module load hdf5
module load cuda/8.0.54
module load spectrum-mpi
source $OLCF_SPECTRUM_MPI_ROOT/jsm_pmix/bin/export_smpi_env -gpu

# jsrun is replaced by 'flux run'. The resource allocation is now based on the Flux directives.
# The jsrun flags `-n8 -a1 -g1 -c1 -r1` are complex to translate directly.
# This conversion assumes 8 tasks total, one per node, each with 1 core and 1 gpu.
/usr/bin/time -f 'ExE_Time: %e' flux run -n 8 -N 1 --cores-per-task=1 --gpus-per-task=1 ./run_8g_weak.sh
/usr/bin/time -f 'ExE_Time: %e' flux run -n 8 -N 1 --cores-per-task=1 --gpus-per-task=1 ./run_8g_weak.sh
/usr/bin/time -f 'ExE_Time: %e' flux run -n 8 -N 1 --cores-per-task=1 --gpus-per-task=1 ./run_8g_weak.sh
/usr/bin/time -f 'ExE_Time: %e' flux run -n 8 -N 1 --cores-per-task=1 --gpus-per-task=1 ./run_8g_weak.sh
/usr/bin/time -f 'ExE_Time: %e' flux run -n 8 -N 1 --cores-per-task=1 --gpus-per-task=1 ./run_8g_weak.sh
