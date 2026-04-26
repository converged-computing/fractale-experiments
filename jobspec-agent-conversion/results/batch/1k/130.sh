#!/bin/bash
#FLUX: --job-name=nalu_build_gcc
#FLUX: --nodes=1
#FLUX: --cores=24
#FLUX: --time-limit=4h

# The PBS directive to join stdout/stderr (-j oe) has no direct analog in the provided flux submit options.
# The PBS umask setting (-W umask=002) has no direct analog in the provided flux submit options.

#Script for installing Nalu on Merlin using Spack with GCC compiler

# Function for printing and executing commands
cmd() {
  echo "+ $@"
  eval "$@"
}

set -e

cmd "module purge"
cmd "module load GCCcore/4.9.2"
cmd "source ../configs/shared-constraints.sh"
cmd "spack install nalu-wind %gcc@4.9.2 ^${TRILINOS}@develop"
