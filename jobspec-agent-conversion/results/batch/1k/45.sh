#!/bin/bash
#FLUX: --job-name=ALT_HKNN_v3_5_job
#FLUX: --ntasks=1
#FLUX: --time-limit=10d
#FLUX: --output=logfiles/ALT_HKNN_v3_5_job.log

singularity exec docker://alleninst/mapping_on_hpc Rscript R_scripts/v3_HKNN_5_ALT.R > logfiles/v3_HKNN_5_ALT_logfile
