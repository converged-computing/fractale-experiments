#!/bin/bash
#FLUX: --nodes=1
#FLUX: --tasks-per-node=1
#FLUX: --time-limit=24h
#FLUX: --requires=haswell
#FLUX: --output=<Processing Folder>
#FLUX: --error=<Processing Folder>

# The PBS memory request 'mem=8gb' has no direct Flux analog in the provided documentation.
# NOTE: You must replace all placeholders like <Processing Folder> with actual paths.

module load singularity-3.2.1

singularity exec -B <directory of run_qunex.sh>,<directory of parameter file>,<directory of gradient_coefficient_files>:/export/HCP/gradient_coefficient_files <path to qunex oontainer/qunex.sif> <directory of run_qunex.sh>/run_qunex.sh \
  --parameterfolder=<directory of parameter file> \
  --studyfolder=<Processing Folder>/<subject_name> \
  --subjects=<subject_name> \
  --scan=<scan_name> \
  --overwrite=yes \
  --hcppipelineprocess=FunctionalPreprocessing
