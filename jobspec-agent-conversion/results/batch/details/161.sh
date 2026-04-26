#!/bin/bash
# The -o log_%1 directive is noted, but the script body handles its own redirection.
# The --partition=GPU and --qos=low directives are ignored as per instructions.
#FLUX: --nodes=1
#FLUX: --tasks-per-node=6
#FLUX: --gpus-per-node=1

# 导入运行环境
module load matlab/R2022a 

# 生成machinefile
NCL=$1

# MPI跨节点运行
# The script handles its own output redirection, so no --output flag is needed.
matlab -nodesktop -nosplash -nodisplay -r "NCL=$NCL;Spec_main;quit" >> log_$NCL
