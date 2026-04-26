#!/bin/bash -l
#FLUX: --nodes=80
#FLUX: --tasks-per-node=8
#FLUX: --ntasks=640
#FLUX: --time-limit=1h30m

# NOTE: The -j oe (join output/error) option and memory requests are not supported.

# cd $PBS_O_WORKDIR # This is the default behavior in Flux

source set_env

echo "using flux run"

# The original script launched one worker per node via ssh.
# This is converted to launch 80 workers, one on each of the 80 nodes.
flux run -n 80 -N 1 $dbwf_bin_dir/db_worker_shell_v1

wait
