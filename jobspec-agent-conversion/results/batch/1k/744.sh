#!/bin/bash -l

#FLUX: --job-name=VQS
#FLUX: --ntasks=1
#FLUX: --cores-per-task=1
#FLUX: --gpus-per-task=1
#FLUX: --time-limit=1h

# cd $PBS_O_WORKDIR # This is the default behavior in Flux
echo Working directory is $(pwd)

# Print some other environment information
echo Running on host `hostname`
echo Time is `date`
echo Directory is `pwd`
echo This job runs on the following processors:
NODES=$(hostname)
echo $NODES
echo Queue: saivt_igpu # Static value from original script
# Compute the number of processors
NPROCS=1
echo This job has allocated $NPROCS nodes
echo -----


# put module loads here 
module load tensorflow/1.4.1-gpu-m40-foss-2016a-python-3.5.1

python demo.py
