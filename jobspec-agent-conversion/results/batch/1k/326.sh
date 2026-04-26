#!/bin/bash

#FLUX: --time-limit=30m
#FLUX: --nodes=16
#FLUX: --tasks-per-node=1
#FLUX: --job-name=Orkut16_lazy_lazy
#FLUX: --output=output/orkut/Orkut16_lazy_lazy.o
#FLUX: --error=output/orkut/Orkut16_lazy_lazy.e


# # module use /global/common/software/m3169/perlmutter/modulefiles
# module use /global/common/software/m3169/cori/modulefiles

#OpenMP settings:
export OMP_NUM_THREADS=32
export OMP_PLACES=threads
export OMP_PROC_BIND=spread

# The generic 'mpirun' command has been replaced by the standard Flux launcher 'flux mini run'.
# The number of tasks (-n 16) is taken from the resource request.
flux mini run -n 16 ./build/release/tools/mpi-greedi-im -i test-data/orkut_small.txt -w -k 16 -p -d IC -e 0.13 -o Orkut16_lazy_lazy.json --run-streaming=false
