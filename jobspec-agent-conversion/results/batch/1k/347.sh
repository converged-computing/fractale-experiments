#!/bin/bash
#FLUX: --job-name=dask-worker
#FLUX: --nodes=1
#FLUX: --ntasks=9
#FLUX: --cores-per-task=4
#FLUX: --time-limit=11h59m

# The PBS memory request (-l mem=109GB) has no direct analog in the provided flux submit options.
# This may impact job scheduling and resource allocation.
# The PBS directive to join stdout/stderr (-j oe) has no direct analog in the provided flux submit options.

# Setup Environment
module purge
source activate pangeo

# Setup dask worker
SCHEDULER=/glade/scratch/$USER/scheduler.json
dask-mpi --nthreads 4 \
    --memory-limit 12e9 \
    --interface ib0 \
    --no-scheduler --local-directory /glade/scratch/$USER \
    --scheduler-file=$SCHEDULER
