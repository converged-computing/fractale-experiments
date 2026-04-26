#!/bin/bash -l
#
# allocate 1 nodes (4 CPUs) for 3 hours
#FLUX: --nodes=1
#FLUX: --cores=4
#FLUX: --gpus-per-node=1
#FLUX: --time-limit=10m
#
# job name
#FLUX: --job-name=CNN_Training
# stdout and stderr files
#FLUX: --output=/home/hpc/capm/sn0515/UVWireRecon/logs/${FLUX_JOB_ID}.out
#FLUX: --error=/home/hpc/capm/sn0515/UVWireRecon/logs/${FLUX_JOB_ID}.err
#
# first non-empty non-comment line ends PBS options

# jobs always start in $HOME -
#source $HPC/.bash_profile

CodeFolder=$HPC/UVWireRecon/
cd ${CodeFolder}

# run
echo -e -n "Start:\t" && date

module load python/2.7-anaconda
# load conda virtualenv
source activate tensorflow
# required:
module use -a /home/vault/capn/shared/apps/U16/modules

echo "$CodeFolder/wrapper.sh $config"
#bash wrapper.sh $config

wait

echo -e -n "Ende:\t" && date 

# The final 'qdel ${PBS_JOBID}' command from the original script has been removed.
# Jobs are expected to terminate naturally, and self-deletion is not a standard practice.
