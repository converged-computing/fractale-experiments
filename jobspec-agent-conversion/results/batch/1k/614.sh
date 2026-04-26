#!/bin/bash -l
# The PBS resource request is translated to the following flux directives:
#FLUX: --nodes=3
#FLUX: --tasks-per-node=128
# The -l mem=64gb directive has no direct flux analog and is omitted.
#FLUX: --time-limit=1h
# The -r n (not re-runnable) directive has no direct flux analog and is omitted.
# The -j oe (join output/error) directive is the default behavior in Flux when no -o/-e are specified.
# The -q starq (queue) directive is ignored as per instructions.

# go to your working directory containing the batch script, code and data
cd /fs/lustre/cita/zack/jl/dev/LagrangianPerturbationTheory/projectamd
module load openmpi

julia --project -e 'using Pkg; Pkg.instantiate()'
julia --project -e 'using Pkg; Pkg.precompile()'

# The custom mpiexecjl command is replaced by `flux mini run`
flux mini run --project -n 192 julia fft_filter_6144.jl
