#!/bin/bash
#FLUX: --job-name=TACHE
#FLUX: --requires=k80
#FLUX: --time-limit=6h
#FLUX: --nodes=1
#FLUX: --gpus-per-node=1

# The -S, -A, and -q directives were ignored as per instructions.
# The commented-out advres directive was not translated.

# do not execute on login nodes
module --force purge

PATH=$PATH:/opt/software/singularity-3.0/bin/

# set the working directory to where the job is launched
# This is the default behavior in Flux.

# Singularity options 
IMAGE=/rap/jvb-000-aa/COURS2019/etudiants/ift6759.simg
RAP=/rap/jvb-000-aa/COURS2019/etudiants/$USER 

mkdir -p $RAP 

singularity exec --nv -B $RAP:/home/$USER $IMAGE \
s_exec python3 -u -m horoma train --mode TRAIN_ALL --embedding vae --cluster mini_batch_kmeans
