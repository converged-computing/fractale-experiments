#!/bin/bash

#FLUX: --job-name=y_0_16200
#FLUX: --output=lap.14450.out
#FLUX: --error=lap.14450.out
#FLUX: --nodes=1
#FLUX: -n 1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=1
#FLUX: --gpus-per-task=1

run_dir=.
input_dir=${run_dir}
exe=/beegfs/home/zhangxin/content/LapH/contraction_code/corr_beta6.41_mu_0.2320_ms-0.2050_L32x64/contrac_meson_zero_ro.py    
echo "16200 job starts at" `date` > $run_dir/output_16200.log
$exe $input_dir/input_16200 >> $run_dir/output_16200.log 2>&1
echo "16200 job ends at" `date` >> $run_dir/output_16200.log
