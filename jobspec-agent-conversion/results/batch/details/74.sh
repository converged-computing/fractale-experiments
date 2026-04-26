#!/bin/bash
# The --mail-user and --mail-type directives are ignored.
#FLUX: --ntasks=200
#FLUX: --cores-per-task=1 
# The --account directive is ignored.
#FLUX: --time-limit=8h
# The --mem-per-cpu=4000MB directive has no direct flux analog and is omitted.
#FLUX: --output=/scratch/grovert4/SLURM/slurm-%x-%j.txt

module load StdEnv/2020
module load julia/1.8.5

# The srun command is replaced by `flux mini run`
flux mini run julia SkX_MonoLayer_Run.jl inputParametersMonoLayer
