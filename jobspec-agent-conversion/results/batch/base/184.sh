#!/bin/bash
#FLUX: -t 5d
#FLUX: --cores=10
#FLUX: --gpus-per-node=1
#FLUX: --job-name=3sl
#FLUX: --ntasks=1

# NOTE: The Slurm directive '--mem-per-cpu=10240' (requesting ~100GB total) was omitted as there is no direct Flux equivalent.
# This may cause the job to fail if scheduled on a node with insufficient memory.
# NOTE: The Slurm directive '--export=ALL' is the default behavior in Flux and was omitted.

module load anaconda
conda activate ilab
export PYTHONPATH="/adapt/nobackup/people/jacaraba/development/tensorflow-caney"

#Run tasks sequentially without ‘&’
# The 'srun' command is not necessary for a single task in Flux.
python /adapt/nobackup/people/jacaraba/development/senegal-lcluc-tensorflow/projects/land_cover/scripts/predict.py \
	-c /adapt/nobackup/people/jacaraba/development/senegal-lcluc-tensorflow/projects/land_cover/configs/20220620/land_cover_256_trees_srv.yaml


