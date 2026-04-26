#!/bin/bash

#FLUX: --job-name=y_0_13650
#FLUX: --output=lap.14450.out
#FLUX: --error=lap.14450.out
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=1
#FLUX: --gpus-per-task=1

run_dir=.
input_dir=${run_dir}
exe=/beegfs/home/zhangxin/content/LapH/contraction_code/contrac_meson_zero_ro.py    
echo "13650 job starts at" `date` > $run_dir/output_13650.log
$exe $input_dir/input_13650 >> $run_dir/output_13650.log 2>&1
echo "13650 job ends at" `date` >> $run_dir/output_13650.log
