#!/bin/bash
#FLUX: --nodes=4
#FLUX: --tasks-per-node=8
#FLUX: --ntasks=32
#FLUX: --time-limit=1h
#FLUX: --cwd=.

# Setup environment
source ../../conf/setup_hpcc.sh

# Export CUDA library paths
#export LD_LIBRARY_PATH=/usr/usc/cuda/5.0/lib64:$LD_LIBRARY_PATH

# List the compute nodes assigned to the code
echo "Compute nodes:"
flux resource list -o hosts
echo ""

# Execute program
./run_benchmark_valgrind.sh

echo "Done."


