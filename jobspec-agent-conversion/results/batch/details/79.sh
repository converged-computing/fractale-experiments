#!/bin/bash
# Begin Flux directives
#FLUX: --job-name=ytopt
#FLUX: --output=output.log
#FLUX: --error=output.err
#FLUX: --time-limit=30m
#FLUX: --nodes=4096

export OMP_NUM_THREADS=168

# WARNING: The 'jsrun' command was removed as it has no Flux equivalent.
# The following commands will run serially on the lead node, not in parallel across all nodes.
../amg2013 -laplace -P 16 16 16 -n 100 100 100  > out.txt
../amg2013 -laplace -P 16 16 16 -n 100 100 100  > out2.txt
../amg2013 -laplace -P 16 16 16 -n 100 100 100  > out3.txt
../amg2013 -laplace -P 16 16 16 -n 100 100 100  > out4.txt
../amg2013 -laplace -P 16 16 16 -n 100 100 100  > out5.txt
