#!/bin/bash -l
 
#FLUX: --job-name=vaegan-pipeline
#FLUX: --ntasks=10
#FLUX: --nodes=1
#FLUX: --time-limit=3d
#FLUX: --error=run.err
#FLUX: --output=run.out
#FLUX: --gpus-per-task=1


# set up env
source /etc/profile.d/modules.sh
export MODULEPATH=/usr/share/Modules/modulefiles:/opt/modulefiles:/afs/slac/package/singularity/modulefiles
module purge
module load PrgEnv-gcc/4.8.5

# change working directory
cd ~/gpfs_home/code/vaetree/

# run the command
singularity run --bind /gpfs,/scratch \
                --bind /gpfs/slac/cryo/fs1/u/nmiolane/data:/data \
                --bind /gpfs/slac/cryo/fs1/u/nmiolane:/home \
                --bind /gpfs/slac/cryo/fs1/u/nmiolane/results:/results \
                --nv ../simgs/toypipeline.simg
