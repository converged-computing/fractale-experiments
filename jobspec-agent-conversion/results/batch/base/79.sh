#!/bin/bash
#FLUX: --bank=MED106
#FLUX: --job-name=ytopt
#FLUX: --output=output.log
#FLUX: --error=output.err
#FLUX: --requires=gpumps
#FLUX: --time-limit=30m
#FLUX: --nodes=4096


export OMP_NUM_THREADS=168

# The original script used 'jsrun' which is specific to LSF. It has been replaced with 'flux run'.
# The jsrun binding flags (-bpacked:42, -dpacked) have no direct equivalent and have been omitted.
# This may lead to different performance characteristics.
flux run -n 4096 -c 42 ../amg2013 -laplace -P 16 16 16 -n 100 100 100  > out.txt
flux run -n 4096 -c 42 ../amg2013 -laplace -P 16 16 16 -n 100 100 100  > out2.txt
flux run -n 4096 -c 42 ../amg2013 -laplace -P 16 16 16 -n 100 100 100  > out3.txt
flux run -n 4096 -c 42 ../amg2013 -laplace -P 16 16 16 -n 100 100 100  > out4.txt
flux run -n 4096 -c 42 ../amg2013 -laplace -P 16 16 16 -n 100 100 100  > out5.txt
