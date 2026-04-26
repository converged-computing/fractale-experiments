#!/bin/bash
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --output=log/process_join_annotate_counts.out
#FLUX: --error=log/process_join_annotate_counts.err

# The SLURM directive '--mem=16G' could not be translated.
# No time limit was specified in the original script.

eval $(spack load --sh miniconda3)
source activate active-learning
python3 src/process_and_join_counts.py
python3 src/annotate_data.py
