#!/bin/bash
#FLUX: --job-name=cys-background-calibration
#FLUX: --ntasks=1
#FLUX: --nodes=1
#FLUX: --gpus-per-task=1
#FLUX: --time-limit=5d
#FLUX: --output=%J.stdout
#FLUX: --error=%J.stderr

# quit on first error
set -e

# NOTE: Flux jobs typically start in the submission directory,
# so 'cd $LS_SUBCWD' is not necessary.

export PATH="/home/rustenburg/miniconda3/bin:$PATH"

# Use the right conda environment
source activate trypsin

# Launch my program.
module load cuda/9.0
python /lila/home/rustenburg/amino_acid_calibrations/run_calibration.py cys-background-calibration-results/settings.json
