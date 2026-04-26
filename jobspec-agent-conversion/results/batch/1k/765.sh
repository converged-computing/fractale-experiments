#!/bin/bash
#FLUX: --nodes=1
#FLUX: --ntasks-per-node=1
#FLUX: --cores-per-task=1
#FLUX: --time-limit=2h
#FLUX: --job-name=myTest
#FLUX: --output=slurm-output/slurm.out

index=$FLUX_JOB_CC
job=$FLUX_JOB_ID
ppn=1 # Since cpus-per-task is 1
module purge
module load matlab/2018b
export MATLABPATH=$HOME/matlab-output

cat<<EOF | matlab -nodisplay
job_id = str2num(strjoin(regexp('$job','\d','match'), ''))
rng(job_id)
addpath(genpath('$HOME/AISP'))

newdir = '$SCRATCH/cluster$job';

mkdir(newdir);
cluster_fcn(job_id,$index);

rmdir(newdir,'s')


EOF

