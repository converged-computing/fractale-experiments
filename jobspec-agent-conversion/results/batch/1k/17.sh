#!/bin/bash
#FLUX: --job-name=SMplasmid.main
#FLUX: --ntasks=1
#FLUX: --time-limit=1d
#FLUX: --output=mainout.txt
#FLUX: --error=mainerr.txt


bash snakemakeslurm.sh

echo Done!!!
