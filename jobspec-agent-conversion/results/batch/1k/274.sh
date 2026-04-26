#!/bin/sh
#FLUX: --job-name=reann
#FLUX: --error=err
#FLUX: --output=out
#FLUX: --ntasks=1
#FLUX: --gpus-per-task=1

# The LSF queue directive (-q 62v100ib) was ignored as per instructions.
# Job placement will be handled by the default Flux scheduler policy.

module load gpu
/fs08/home/js_wangjj/src/lammps/lammps-29Sep2021/build/lmp_miao -in in.lammps
