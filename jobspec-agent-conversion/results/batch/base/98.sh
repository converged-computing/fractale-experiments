#!/bin/bash
#FLUX: --nodes=1
#FLUX: --cores=16
#FLUX: --time-limit=48h
#FLUX: --job-name=110411_CLASS_all_runs
#FLUX: --output=/N/dc2/projects/lifebid/code/pestillilab_projects/precision_brain_science/s_classify_110411.out
#FLUX: --error=/N/dc2/projects/lifebid/code/pestillilab_projects/precision_brain_science/s_classify_110411.err

# The PBS parameters for email notification (-m and -M) have no direct equivalent in flux-submit.
# You will not receive email notifications for this job.
# The PBS parameter -V is the default behavior in Flux and is not needed.

module load spm
module load matlab
cd /N/dc2/projects/lifebid/code/pestillilab_projects/precision_brain_science/

matlab -nojvm -nosplash -r s_classify_major_tracts_from_fe_structure_110411
