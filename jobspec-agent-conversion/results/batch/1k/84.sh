#!/bin/bash
#FLUX: --job-name=upload_torus
# The -S /bin/bash directive is redundant with the shebang.
#FLUX: --time-limit=48h
# The -l nodes=1:ppn=1 directive is translated to:
#FLUX: --nodes=1
#FLUX: --ntasks=1
# The mem=8gb directive has no direct flux analog and is omitted.
# The output and error files are translated, replacing PBS variables with Flux equivalents.
#FLUX: --output=logs_u/upload_torus.o%j.log
#FLUX: --error=logs_u/upload_torus.e%j.err

module load gcc/6.2.0
module load python/2.7.13

# The PBS_O_WORKDIR variable is replaced by FLUX_JOB_CWD
cd $FLUX_JOB_CWD


gsutil cp -a public-read \
/gpfs/data/im-lab/nas40t2/abarbeira/projects/gtex_v8/torus_eqtl_priors.tar.gz \
gs://gtex-gwas-share/torus/torus_eqtl_priors.tar.gz

#rm /gpfs/data/im-lab/nas40t2/abarbeira/projects/gtex_v8/torus_eqtl_priors.tar.gz
