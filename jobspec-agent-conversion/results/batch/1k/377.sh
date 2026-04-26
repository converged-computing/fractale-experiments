#!/bin/bash
#FLUX: --job-name=sweep_small
#FLUX: --nodes=1
#FLUX: --gpus-per-task=1
#FLUX: --requires=tesla
#FLUX: --cores-per-task=8
#FLUX: --time-limit=8h
#FLUX: --output=%N.%J.VAE_test_loader.out
#FLUX: --error=%N.%J.VAE_test_loader.err

# The --mem=16g directive has no direct analog in the provided flux submit options.
# This may impact job scheduling and resource allocation.
# The --output and --error directives do not support Slurm-style node/job ID substitution (%N, %J).

# Necessary to access existing modules on the cluster
source /etc/profile.d/lmod.sh
source /etc/profile.d/zz_hpcnow-arch.sh

# Load Anaconda Module, Activate Conda CLI and Activate Environment
module load Anaconda3/2020.02
export PATH="/soft/easybuild/x86_64/software/Anaconda3/2020.02/bin:$PATH"
export PATH="$HOME/.conda/envs/GrooveTransformer/bin:$PATH"
source /soft/easybuild/x86_64/software/Anaconda3/2020.02/etc/profile.d/conda.sh
conda activate GrooveTransformer

# Login to WANDB
export WANDB_API_KEY=API_KEY
python -m wandb login

# Run your codes here

cd GrooveTransformer
#wandb agent mmil_vae_g2d/SmallSweeps_MGT_VAE/bib6bpsb
python train.py
