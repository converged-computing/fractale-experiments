#!/bin/bash
#FLUX: --job-name=upload_torus
#FLUX: -t 2d
#FLUX: --nodes=1
#FLUX: --cores=1
#FLUX: --output=logs_u/upload_torus.o{flux:id}.log
#FLUX: --error=logs_u/upload_torus.e{flux:id}.err

# NOTE: The PBS directive '#PBS -l mem=8gb' was omitted as there is no direct Flux equivalent.
# This could lead to the job being scheduled on a node with insufficient memory.
# NOTE: The PBS syntax for dynamic output filenames (e.g., using ${PBS_JOBID}) has been
# translated to a common Flux pattern ({flux:id}), but this is not guaranteed to work.

module load gcc/6.2.0
module load python/2.7.13

# By default, Flux starts the job in the submission directory, similar to $PBS_O_WORKDIR
cd $FLUX_SUBMIT_CWD


gsutil cp -a public-read \
/gpfs/data/im-lab/nas40t2/abarbeira/projects/gtex_v8/torus_eqtl_priors.tar.gz \
gs://gtex-gwas-share/torus/torus_eqtl_priors.tar.gz

#rm /gpfs/data/im-lab/nas40t2/abarbeira/projects/gtex_v8/torus_eqtl_priors.tar.gz
