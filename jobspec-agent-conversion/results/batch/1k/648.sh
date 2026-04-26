#!/bin/bash
#FLUX: --cores=4

# The original srun command is replaced with flux run.
flux run singularity exec --nv ../images/bark_ml.img python3 -u ./configuration 
