#!/bin/bash -l

#FLUX: --job-name=Nextflow-master-trinity
#FLUX: --time-limit=4d

# The --no-requeue directive has no direct analog in the provided flux submit options.
# The --export=none directive has no direct analog in the provided flux submit options.
# The account and partition directives were ignored as per instructions.

module load singularity  # only needed if containers are yet to be downloaded
module load nextflow

nextflow run marcodelapierre/trinity-nf \
  --reads='reads_{1,2}.fq.gz' \
  -profile zeus --slurm_account='director2172' \
  -name nxf-${FLUX_JOB_ID} \
  -with-trace trace-${FLUX_JOB_ID}.txt \
  -with-report report-${FLUX_JOB_ID}.html
