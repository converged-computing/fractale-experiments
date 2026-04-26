#!/bin/bash -x
#FLUX: --nodes=1
#FLUX: --tasks-per-node=4
#FLUX: --output=run.out
#FLUX: --error=run.err
#FLUX: --time-limit=30m

export LD_PRELOAD=$EBROOTIMKL/mkl/lib/intel64/libmkl_def.so:$EBROOTIMKL/mkl/lib/intel64/libmkl_avx2.so:$EBROOTIMKL/mkl/lib/intel64/libmkl_core.so:$EBROOTIMKL/mkl/lib/intel64/libmkl_intel_lp64.so:$EBROOTIMKL/mkl/lib/intel64/libmkl_intel_thread.so:$EBROOTIMKL/lib/intel64/libiomp5.so

export PYTHONPATH=$PYTHONPATH:/p/project/ccstma/cstma000/pySDC
python pySDC_with_PETSc.py 1
touch ready
