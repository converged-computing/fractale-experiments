#!/bin/bash
#FLUX: --ntasks=200
#FLUX: --cores-per-task=1
#FLUX: --bank=def-aparamek
#FLUX: --time-limit=8h
#FLUX: --output=/scratch/grovert4/SLURM/slurm-{job-name}-{id}.txt

# The SLURM --mail-user and --mail-type directives have no direct Flux analog.
# The SLURM --mem-per-cpu directive has no direct Flux analog in the provided documentation.

module load StdEnv/2020
module load julia/1.8.5

# The srun command is replaced by flux mini run.
flux mini run -n 200 julia SkX_MonoLayer_Run.jl inputParametersMonoLayer
