#!/bin/bash

#FLUX: --nodes=1
#FLUX: --tasks-per-node=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=10
#FLUX: --time-limit=70h
#FLUX: --job-name=LJ5-NS
#FLUX: --cwd=/scratch/tje3676/RESEARCH/ML_LANDSCAPES/nested_sampling/examples/LJ/

# Initialize
module purge
source ~/.bashrc

# Run
singularity exec \
	    --overlay /scratch/tje3676/RESEARCH/research_container.ext3:ro \
	    /scratch/work/public/singularity/cuda11.6.124-cudnn8.4.0.27-devel-ubuntu20.04.4.sif\
	    /bin/bash -c "source /ext3/env.sh; conda activate cb3-3.9; export PYTHONPATH=/scratch/tje3676/RESEARCH/pele/:/scratch/tje3676/RESEARCH/ML_LANDSCAPES/nested_sampling/:/scratch/tje3676/RESEARCH/mcpele/; python LennardJonesNVT.py -K 700 -N 1 -S 2000000 -P 5 -D 0.0023 -sig 1.0 -eps 1.0 -dim 3"

