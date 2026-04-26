#!/bin/bash
#    Begin LSF directives
#FLUX: --time-limit=2m
#FLUX: --nodes=1
#FLUX: --job-name=gs-julia
#FLUX: --output=output.%J
#FLUX: --error=output.%J 
#    End BSUB directives and begin shell commands

# launch this file with bsub `$ bsub job_summit.sh` 
# in a directory containing a settings-files.json file
# example file provided in GrayScott.jl/examples/settings-files.json

date
# Modify for your account other than csc383/user
GS_DIR=/gpfs/alpine/proj-shared/csc383/wgodoy/GrayScott.jl
GS_EXE=$GS_DIR/gray-scott.jl

# GPU runs
# jsrun is replaced by 'flux run'. Resources are defined by the job spec.
flux run -n 1 -g 1 julia --project=$GS_DIR $GS_EXE settings-files.json

# Multithreaded CPU runs:
# ncores=8
# jsrun -n 1 -c $ncores -g 1 julia --project=$GS_DIR -t $ncores $GS_EXE settings-files.json
