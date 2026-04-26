#!/bin/sh
#FLUX: --job-name=PCC_optimzer
#FLUX: --queue=elektro
#FLUX: --ntasks=1
#FLUX: --nodes=1
#FLUX: --time-limit=20h
#FLUX: --output=output_alex_run1.out
#FLUX: --error=error_alex_run1.err

# The LSF memory requests (-R "rusage[mem=2GB]" and -M 10GB) have no direct Flux analog in the provided documentation.
# The LSF email notification directives (-u, -B, -N) have no direct Flux analog.

module load cvx
module load mosek/9.2
##module load gurobi/8.1.1

matlab -nodisplay -r RUN_PCC_optim -logfile PCC_optim_logfile_output


##BSUB -m "n-62-21-94"
