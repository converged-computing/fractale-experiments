#!/bin/bash
#FLUX: --job-name=CaseScaff2.SM.main
#FLUX: --ntasks=1
#FLUX: --time=1d
#FLUX: --output=mainout.txt
#FLUX: --error=mainerr.txt

# The --mem slurm parameter has no direct analog in flux submit.
# This may affect job scheduling and performance if the job is memory-intensive.

bash snakemakeslurm.sh

echo Done!!!
