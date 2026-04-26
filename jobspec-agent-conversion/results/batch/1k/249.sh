#!/bin/bash
#FLUX: --job-name=example
#FLUX: --output=example.out
#FLUX: --nodes=1
#FLUX: --gpus-per-node=1
#FLUX: --exclusive

module purge
module load namd/2.12/gpu

# set Lustre striping if lfs is available
if command -v lfs &> /dev/null
then
    lfs setstripe -c 2 $(pwd)
fi

# Get total cores available to the job
N=$(flux resource list -o "{{.ncores}}")

# calculate total processes (P) and procs per node (PPN)
PPN=$(($N - 1))

flux mini run -n $PPN $(which namd2) example.conf
