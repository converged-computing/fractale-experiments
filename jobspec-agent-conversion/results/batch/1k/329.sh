#!/bin/sh
#FLUX: -N 1
#FLUX: -n 4 
#FLUX: -c 2 
#FLUX: -g 1
#FLUX: -t 8h

# The Slurm directives for account (-A) and partition (-p) were ignored as per instructions.

flux mini run -n 4 /global/home/users/mariusmillea/src/julia-1.5.2/bin/julia \
    --project=/global/home/users/mariusmillea/work/ptsrclens/Project.toml \
    -e 'using ClusterManagers; ClusterManagers.elastic_worker("marius          ","10.0.0.24",9312)'
