#!/bin/bash
#FLUX: --job-name=APPLICATION
#FLUX: --ntasks=1
#FLUX: --cores-per-task=1
#FLUX: --tasks-per-node=1
#FLUX: -t 3m
#FLUX: --output=APPLICATION.log
#FLUX: --error=APPLICATION.log

# NOTE: The PBS directive '-j oe' was handled by setting output and error paths to be the same.
# NOTE: Cray-specific directives (mppwidth, mppdepth, mppnppn) were translated to their logical Flux equivalents.

# #FLUX: -q gpu_nodes  # uncomment this line for raven

