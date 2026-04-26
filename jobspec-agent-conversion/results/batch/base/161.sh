#!/bin/bash
#FLUX: --partition=GPU
#FLUX: --nodes=1
#FLUX: --ntasks=6
#FLUX: --gpus-per-node=1
#FLUX: --output=flux_job_{id}.out

# The --qos=low parameter from slurm has no direct equivalent in flux-submit.
# The job will run with the default quality of service for the queue.

# 导入运行环境
module load matlab/R2022a 

# 生成machinefile
NCL=$1

# MPI跨节点运行
matlab -nodesktop -nosplash -nodisplay -r "NCL=$NCL;Spec_main;quit" >> log_$NCL
