#!/bin/bash
#
# The --partition=gpu8_long directive is ignored as per instructions.
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --gpus-per-task=1
#FLUX: --time-limit=5d13h
# The --mem=70GB directive has no direct flux analog and is omitted.
# The --mail-type and --mail-user directives are ignored as per instructions.
#FLUX: --output=foo.txt

module load matlab/

module load anaconda3/cpu/5.2.0
module load cuda90/toolkit/9.1.176
module load cuda90/fft/9.1.176

cd /scratch/td2201/

python ml_is_good.py


