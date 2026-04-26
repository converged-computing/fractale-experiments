#!/bin/sh
#FLUX: --job-name=PCC_optimzer
# The -q elektro (queue) directive is ignored as per instructions.
#FLUX: --ntasks=1
# The -R "rusage[mem=2GB]" directive has no direct flux analog and is omitted.
# The -M 10GB directive has no direct flux analog and is omitted.
#FLUX: --time-limit=20h
# The -u, -B, and -N mail directives are ignored as per instructions.
#FLUX: --output=output_alex_run1.out
#FLUX: --error=error_alex_run1.err
# The -R "span[hosts=1]" directive is translated to --nodes=1
#FLUX: --nodes=1

module load cvx
module load mosek/9.2
##module load gurobi/8.1.1

matlab -nodisplay -r RUN_PCC_optim -logfile PCC_optim_logfile_output


##BSUB -m "n-62-21-94"
