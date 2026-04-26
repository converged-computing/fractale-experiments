#!/bin/bash
#FLUX: --time-limit=2d
#FLUX: --ntasks=1
#FLUX: --cores-per-task=4
#FLUX: --output=slurm/real/%A_%a.out


# NOTE: The %A and %a format specifiers are not supported in Flux; files will be overwritten.

# load the required modules
module load r
module load gcc/11.2.0

# singularity run -B /scratch,/m,/l,/share /scratch/cs/bayes_ave/stan-triton.sif Rscript ./R/real-world/ionosphere.R $1 $2
# srun is not required for a single-task job in Flux
Rscript ./R/real-world/ionosphere.R $1 $2
