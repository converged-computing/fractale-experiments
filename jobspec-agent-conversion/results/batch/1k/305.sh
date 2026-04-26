#!/bin/sh
#FLUX: --job-name=NSCF.Na@G
#FLUX: --ntasks=24
#FLUX: --output=%J.opt
#FLUX: --error=%J.err
#FLUX: --time-limit=1000h
#FLUX: --tasks-per-node=12

# The LSF directives -a (application type) and -R (resource span) have no direct analogs in Flux.
# The -q (queue) directive was ignored as per instructions.
# LSF filename substitutions (%J) are not supported by Flux.

/home/xuzp/bin/vasp5.3.5_isif_cc  >& log
