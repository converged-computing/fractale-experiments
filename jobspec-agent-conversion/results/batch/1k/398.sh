#!/bin/bash
#FLUX: --job-name=newInstancesSubset
#FLUX: --time-limit=24h
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=1
#FLUX: --cc=1-995

# Load the required modules
module load gcccore/10.2.0
module load cmake/3.18.4
module load eigen/3.3.8
# Move into folder and run, each have a total of 5968 so
# have 995 runs with 6 lines each.
cd ../cpp_code
./main newInstancesTesting ${FLUX_JOB_CC} 6
