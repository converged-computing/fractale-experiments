#!/bin/bash
# The consolidated SBATCH directive is broken down into its Flux equivalents.
#FLUX: --time-limit=5d
#FLUX: --ntasks=1
#FLUX: --cores-per-task=10
# The --mem-per-cpu=10240 directive has no direct flux analog and is omitted.
#FLUX: --gpus-per-task=1
#FLUX: --job-name=3sl
# The --export=ALL directive is the default behavior in flux and is omitted.

module load anaconda
conda activate ilab
export PYTHONPATH="/adapt/nobackup/people/jacaraba/development/tensorflow-caney"

#Run tasks sequentially without ‘&’
# The srun command is not needed for a single-process job and has been removed.
python /adapt/nobackup/people/jacaraba/development/senegal-lcluc-tensorflow/projects/land_cover/scripts/predict.py \
	-c /adapt/nobackup/people/jacaraba/development/senegal-lcluc-tensorflow/projects/land_cover/configs/20220620/land_cover_256_trees_srv.yaml
