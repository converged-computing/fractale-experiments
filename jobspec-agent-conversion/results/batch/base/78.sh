#!/bin/bash

# This script combines the logic of the original two-part submission process.

# Set the number of nodes
nnds=8

#--- process processexe.pl to change the number of nodes
# This step from the original script is preserved.
./processcp.pl ${nnds}

# FLUX directives translated from COBALT
#COBALT -n ${nnds} -t 60 -O runs${nnds} -qdebug-cache-quad  -A EE-ECP
#FLUX: --nodes=${nnds}
#FLUX: --time-limit=60m
#FLUX: --job-name=runs${nnds}
#FLUX: --output=runs${nnds}.out
#FLUX: --error=runs${nnds}.err
#FLUX: --queue=debug-cache-quad
#FLUX: --bank=EE-ECP

# Environment setup from the original script
module load miniconda-3/latest
source activate yt

# The command to be executed
python3 -m ytopt.search.ambs --evaluator ray --problem problem.Problem --max-evals=3 --learner RF
