#!/bin/bash
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --requires=haswell
#FLUX: --time-limit=24h

# The PBS directive for memory ('-l mem=8gb') could not be translated.
# The output and error directives pointed to a placeholder and have been omitted.
# #PBS -o <Processing Folder>
# #PBS -e <Processing Folder>

# CRITICAL: This script is a template. You must replace all placeholders
# surrounded by angle brackets (e.g., <directory of run_qunex.sh>)
# with actual paths and names before submitting.

module load singularity-3.2.1

singularity exec -B <directory of run_qunex.sh>,<directory of parameter file>,<directory of gradient_coefficient_files>:/export/HCP/gradient_coefficient_files <path to qunex oontainer/qunex.sif> <directory of run_qunex.sh>/run_qunex.sh \
  --parameterfolder=<directory of parameter file> \
  --studyfolder=<Processing Folder>/<subject_name> \
  --subjects=<subject_name> \
  --scan=<scan_name> \
  --overwrite=yes \
  --hcppipelineprocess=FunctionalPreprocessing
