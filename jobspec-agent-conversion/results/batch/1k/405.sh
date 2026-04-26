#!/bin/bash
#FLUX: --nodes=1
#FLUX: --cores-per-task=64
#FLUX: --time-limit=120h
#FLUX: --output=/mnt/beegfs/XNAT/COGITATE/ECoG/phase_2/processed/bids/derivatives/decoding_analysis/slurm-%A_%a.out
#FLUX: --job-name=decoding

# The --mem=80000 directive has no direct analog in the provided flux submit options.
# This may impact job scheduling and resource allocation.
# The --output directive does not support Slurm-style job array substitutions (%A, %a).
# The output filename will be literal.

config=""
while [ $# -gt 0 ]; do
  case "$1" in
    --config=*)
      config="${1#*=}"
      ;;
    *)
      printf "***************************\n"
      printf "* Error: Invalid argument: ${1}*\n"
      printf "***************************\n"
      exit 1

  esac
  shift
  echo ${participant_id}
  echo ${config}
done

cd /hpc/users/$USER/sw/github/ECoG

module purge; module load Anaconda3/2020.11; source /hpc/shared/EasyBuild/apps/Anaconda3/2020.11/bin/activate; 
conda activate /hpc/users/$USER/.conda/envs/cogitate_ecog

export PYTHONPATH=$PYTHONPATH:/hpc/users/$USER/sw/github/ECoG

python decoding/decoding_master.py --config "${config}"
