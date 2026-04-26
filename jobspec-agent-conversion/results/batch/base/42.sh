#!/bin/bash

#FLUX: --nodes=1
#FLUX: --ntasks=24
#FLUX: --time-limit=6h
#FLUX: --queue=normal
#FLUX: --output=slurm.{id}.out
#FLUX: --error=slurm.{id}.err
#FLUX: --env=-*

# The --mail-type and --mail-user parameters from slurm have no direct equivalent in flux-submit.
# You will not receive email notifications for this job.

module purge

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

source "$HOME/.cargo/env"
cargo run
