#!/bin/sh

#FLUX: -q cpu-short
#FLUX: --job-name=mcmicro_SMM_multisample
#FLUX: --output=mcmicro-{flux:jobid}.log
#FLUX: -t 2h
#FLUX: --cwd=/research/labs/hematology/hemedata/m302618/projects/spatial/cdx_pipeline_mforge/MCMICRO/

# NOTE: The Slurm directive '--mem=4G' was omitted as there is no direct Flux equivalent.
# This may cause the job to fail if scheduled on a node with insufficient memory.
# NOTE: The Slurm directives for email notification ('--mail-type', '--mail-user') were omitted as there are no direct Flux equivalents.

module purge
module load nextflow
module load apptainer

export NXF_APPTAINER_CACHEDIR="/research/labs/hematology/hemedata/m302618/apptainer/containers"

nextflow -C mforge_settings.config run labsyspharm/mcmicro --in 20240112_BR062124_Gonsalves_CD45 -with-report
