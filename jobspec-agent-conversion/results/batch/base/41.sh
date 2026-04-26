#!/bin/bash
#
#FLUX: --queue=gpu8_long
#FLUX: --nodes=1
#FLUX: --tasks-per-node=1
#FLUX: --gpus-per-node=1
#FLUX: --time-limit=5d13h
#FLUX: --output=foo.txt

# The SLURM --mem directive has no direct Flux analog in the provided documentation.
# The SLURM --mail-type and --mail-user directives have no direct Flux analog.

module load matlab/

module load anaconda3/cpu/5.2.0
module load cuda90/toolkit/9.1.176
module load cuda90/fft/9.1.176

cd /scratch/td2201/

python ml_is_good.py
