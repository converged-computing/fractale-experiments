#!/bin/bash
#FLUX: --nodes=1
#FLUX: --time-limit=60m
#FLUX: --job-name=runs1
#FLUX: --ntasks=1

module load miniconda-3/latest
source activate yt

python3 -m ytopt.search.ambs --evaluator ray --problem problem.Problem --max-evals=200 --learner RF


