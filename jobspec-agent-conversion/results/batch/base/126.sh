#!/bin/bash -l
#FLUX: --nodes=3
#FLUX: --ntasks=192
#FLUX: --tasks-per-node=64
#FLUX: --time-limit=1h
#FLUX: --queue=starq

# The PBS memory request 'mem=64gb' has no direct equivalent in flux-submit.
# The job may fail due to insufficient memory.
# The PBS 'not rerunnable' (-r n) and 'join output' (-j oe) flags have no direct equivalents.

# The 'cd' command to the submission directory is the default behavior in Flux and is not needed.

module load openmpi

julia --project -e 'using Pkg; Pkg.instantiate()'
julia --project -e 'using Pkg; Pkg.precompile()'

# The mpiexecjl command is replaced with flux run.
# Flux will launch 192 tasks, distributed with 64 tasks per node across the 3 nodes.
flux run julia fft_filter_6144.jl
