#!/bin/bash
#FLUX: --job-name=LPS_cape
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=1
#FLUX: --time-limit=2d
#FLUX: --output=slurm.%N.%j.out
#FLUX: --error=slurm.%N.%j.err

# NOTE: The %N and %j format specifiers are not supported in Flux; files will be overwritten.

#for now set arguments in Rmd file
# example use: sbatch -q long LPS_cape

# NOTE: Flux jobs typically start in the submission directory, so 'cd $SLURM_SUBMIT_DIR' is not needed.
# cd $SLURM_SUBMIT_DIR

module load singularity

singularity exec ../../../Containers/R.sif R -e 'rmarkdown::render(here::here("Documents", "LPS_Sensitivity.Rmd"))'
