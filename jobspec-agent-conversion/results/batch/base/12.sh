#!/bin/bash

#FLUX: -B CSC275MCCLURE
#FLUX: --job-name=COLOR
#FLUX: --output=color-3600g.o{flux:id}
#FLUX: -t 10m
#FLUX: --nodes=600
# The following directives were derived from the 'jsrun' command in the original script
#FLUX: --ntasks=3600
#FLUX: --tasks-per-node=6
#FLUX: --cores-per-task=1
#FLUX: --gpus-per-task=1

# #FLUX: --requires=NVME # Translation of commented-out LSF directive
 
# NOTE: The LSF project directive '-P' has been mapped to the Flux bank directive '-B'.
# NOTE: The 'jsrun' command and its resource flags have been replaced by 'flux mini run'
#       and corresponding top-level Flux directives.
# NOTE: The Spectrum MPI argument '--smpiargs="-gpu"' has been omitted, as it is expected
#       that the MPI library will correctly detect the GPU environment set up by Flux.

date

module load gcc cuda 
#source $OLCF_SPECTRUM_MPI_ROOT/jsm_pmix/bin/export_smpi_env -gpu

export LBPM_WIA_DIR=$HOME/summit/build/LBPM-WIA/tests

cd /gpfs/alpinetds/csc275/scratch/mcclurej/SCALING/WEAK/3600p

# The jsrun command is replaced by 'flux mini run'
flux mini run -n 3600 $LBPM_WIA_DIR/TestCommD3Q19


exit;

