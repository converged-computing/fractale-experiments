#!/bin/bash
#FLUX: --nodes=1
#FLUX: --cores=20
#FLUX: --time-limit=20h
#FLUX: --job-name=all_new_fp_small_custom1

# The PBS memory request (-lselect mem=128gb) has no direct analog in the provided flux submit options.
# This may impact job scheduling and resource allocation.
# The cd to $PBS_O_WORKDIR was removed as Flux starts in the submission directory by default.

# PBS_O_WORKDIR and TMPDIR are both loaded as env variables
# better to copy scripts to and from TMPDIR

# Load production environment first
module load tools/prod
# module load SciPy-bundle/2022.05-foss-2022a
# module load julia/1.6.4 

# run the program
# python myprog.py path/to/input.txt
../../../julia --threads 20 job.jl
