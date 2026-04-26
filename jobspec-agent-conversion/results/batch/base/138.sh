#!/bin/bash

#FLUX: -B np01
#FLUX: -q normal 
#FLUX: --job-name="{{:name}}"
#FLUX: --ntasks={{:ncpus}}
#FLUX: -t {{:wallhr}}h

# NOTE: The PBS directive '-l mem={{:mem}}GB' was omitted due to no direct Flux translation.
# This may affect job scheduling; the job might be placed on a node without enough memory.
# NOTE: The PBS directive '-j oe' (join stdout/stderr) was omitted as no output file was specified.
# To replicate this, set --output and --error to the same file path.

source $HOME/hpc-environments/gadi/load-intel.sh
PROJECT_DIR=$SCRATCH/{{:dir_name}}/

# The original script used `mpiexec`. The idiomatic way to run this in Flux
# is with `flux mini run`, which uses the allocated resources automatically.
flux mini run -n {{:ncpus}} julia --project=$PROJECT_DIR --check-bounds no -O3 \
    $PROJECT_DIR/scripts/Benchmarks/benchmark_gadi.jl \
    {{:name}} \
    {{{:write_dir}}} \
    {{:type}} \
    {{:bmark_type}} \
    {{:Nx_partition}} \
    {{:Ny_partition}} \
    {{:Nz_partition}} \
    {{:n_el_size}} \
    {{:fe_order}} \
    {{:verbose}} \
    {{:nreps}}

