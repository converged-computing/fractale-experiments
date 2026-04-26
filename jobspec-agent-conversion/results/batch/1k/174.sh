#!/bin/bash
#FLUX: --nodes=1
#FLUX: --ntasks=10
#FLUX: --cores-per-task=2
#FLUX: --time-limit=7h59m
#FLUX: --job-name=Beegenn_sleep_normal_synapses_correlation
#FLUX: --output=beegenn.stdout.txt
#FLUX: --error=beegenn.stderr.txt
#FLUX: --cwd=.

module load cuda-11.1
module load singularity-3.4.0


# NOTE: you need to install squashfs-tools from source, or singularity will fail!
# https://github.com/plougher/squashfs-tools/blob/master/INSTALL
# Make sure to install mksquashfs inside ~/.local so that it can be found in the PATH

rm beegenn_sleep.sif

singularity pull docker://giacthephantom/beegenn:sleep

singularity exec \
  --bind $PBS_O_WORKDIR/genn-network-model/t_30:/t_30,$PBS_O_WORKDIR/outputs:/home/genn \
  --nv \
  docker://giacthephantom/beegenn:sleep \
  python3 -m beegenn.plots.correlation /t_30 t30noinputcluster

