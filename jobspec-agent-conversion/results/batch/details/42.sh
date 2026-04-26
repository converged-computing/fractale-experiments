#!/bin/bash

#FLUX: --nodes=1
#FLUX: --ntasks=24
#FLUX: --time-limit=6h
# The -q normal (QOS) directive is ignored.
#FLUX: --output=slurm.%j.out
#FLUX: --error=slurm.%j.err
# The --mail-type and --mail-user directives are ignored.
# The --export=NONE directive has no direct flux analog and is omitted.

module purge

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

source "$HOME/.cargo/env"
cargo run
