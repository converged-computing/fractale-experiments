#!/bin/bash
#FLUX: --job-name=mpi_examples
#FLUX: --nodes=1
#FLUX: --ntasks=5
#FLUX: --time-limit=10m

# The PBS '-j oe' directive is handled by directing both output streams to the same file.
#FLUX: --output=hawk_job.output
#FLUX: --error=hawk_job.output

# Flux jobs are typically started in the submission directory, so 'cd "$PBS_O_WORKDIR"' is not needed.

# load necessary modules
ml r
ml julia

# run all examples
for f in *.jl
do
    echo "Running $f"
    # The 'mpiexecjl' command has been replaced with the standard Flux launcher 'flux mini run'.
    flux mini run -n 5 julia --project "$f"
done
