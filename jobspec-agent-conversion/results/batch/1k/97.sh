#!/bin/bash
#FLUX: --cores-per-task=8
#FLUX: --time-limit=2h50m
#FLUX: --output=/home/shaws5/projects/def-beckers/shaws5/Research_code/EEGnet/Sharcnet/out_files/process_RunningNFB_loopIDX_83to83-Node%N-JobID%j.out

# The --mem=64G directive has no direct analog in the provided flux submit options.
# This may impact job scheduling and resource allocation.
# The --output directive does not support Slurm-style node name/job ID substitution (%N, %j).
# The output filename will be literal.

module load matlab
cd /home/shaws5/projects/def-beckers/shaws5/Research_code/EEGnet/Sharcnet/sub_files
matlab -nodesktop -nosplash -nodisplay -r "run('process_RunningNFB_loopIDX_83to83.m'); exit"
