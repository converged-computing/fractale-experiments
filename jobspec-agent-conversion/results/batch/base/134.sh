#!/bin/bash
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --output=log/process_join_annotate_counts.out
#FLUX: --error=log/process_join_annotate_counts.err

# The SLURM --mem directive has no direct Flux analog in the provided documentation.
# The SLURM --mail-type directive has no direct Flux analog.

eval $(spack load --sh miniconda3)
source activate active-learning
python3 src/process_and_join_counts.py
python3 src/annotate_data.py
