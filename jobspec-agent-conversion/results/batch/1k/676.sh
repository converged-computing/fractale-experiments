#!/bin/bash

# The -P np01 (project) and -q normal (queue) directives are ignored.
#FLUX: --job-name={{:name}}
# The -l ncpus directive is translated to --ntasks, as this is an MPI job.
#FLUX: --ntasks={{:ncpus}}
# The -l mem={{:mem}}GB directive has no direct flux analog and is omitted.
#FLUX: --time-limit={{:wallhr}}h
# The -j oe (join output/error) directive is the default behavior in Flux if only --output is specified.

source $HOME/hpc-environments/gadi/load-intel.sh
PROJECT_DIR=$SCRATCH/{{:dir_name}}/

# The mpiexec command is replaced by `flux mini run`.
# The -n flag is not needed as flux will launch the correct number of tasks.
flux mini run julia --project=$PROJECT_DIR --check-bounds no -O3 \
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
