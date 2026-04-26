#!/bin/bash -l
#FLUX: --job-name=cubids-validate
#FLUX: --nodes=1
#FLUX: --ntasks-per-node=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=1
#FLUX: --time-limit=20m
#FLUX: --output=output_logs/cubids.out
#FLUX: --error=output_logs/cubids.err
#FLUX: --cwd=/path/to/run_files.cubids


module load singularity

file=run${FLUX_JOB_CC}

bash ${file}

