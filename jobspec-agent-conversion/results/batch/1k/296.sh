#!/bin/sh

# The --partition directive is ignored as per instructions.
#FLUX: --job-name=mcmicro_SMM_multisample
#FLUX: --output=mcmicro-%j.log
#FLUX: --time-limit=2h
# The --mem=4G directive has no direct flux analog and is omitted.
# The --mail-type and --mail-user directives are ignored as per instructions.
#FLUX: --cwd=/research/labs/hematology/hemedata/m302618/projects/spatial/cdx_pipeline_mforge/MCMICRO/

module purge
module load nextflow
module load apptainer

export NXF_APPTAINER_CACHEDIR="/research/labs/hematology/hemedata/m302618/apptainer/containers"

# CRITICAL: The nextflow configuration `mforge_settings.config` may contain Slurm-specific
# settings. This will need to be changed to a Flux-compatible profile.
nextflow -C mforge_settings.config run labsyspharm/mcmicro --in 20240112_BR062124_Gonsalves_CD45 -with-report
