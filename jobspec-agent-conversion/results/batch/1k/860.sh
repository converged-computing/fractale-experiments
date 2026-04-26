#!/bin/bash
#FLUX: --job-name=together-alpa-OPT-175B
#FLUX: --time-limit=1h
#FLUX: --ntasks=1
#FLUX: --cpus-per-task=8
#FLUX: --gpus-per-task=8

# The slurm memory request (--mem-per-cpu) has no direct analog in flux and was omitted.
# The slurm request for a specific GPU model (a100) has no analog and was omitted.
# The slurm node exclusion (--exclude) has no analog and was omitted.

# Slurm's dynamic output/error filenames (%j) are not supported in Flux directives.
# We redirect all output for the script using 'exec' and the FLUX_JOB_ID variable.
exec > /afs/cs.stanford.edu/u/biyuan/fm/together/together-accelerate-OPT-iml-175B-max-${FLUX_JOB_ID}.out 2> /afs/cs.stanford.edu/u/biyuan/fm/together/together-accelerate-OPT-iml-175B-max-${FLUX_JOB_ID}.err

cd /nlp/scr2/nlp/fmStore/fm/dev/Quick_Deployment_HELM

nvidia-smi

# For docker mode:
docker run --rm --gpus '"device=0,1,2,3,4,5,6,7"' --ipc=host -v /nlp/scr2/nlp/fmStore/fm:/home/fm binhang/alpa /home/fm/dev/Quick_Deployment_HELM/start_local_optiml175bmax.sh
