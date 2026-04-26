#!/bin/bash
#FLUX: --gpus-per-task=1
#FLUX: --job-name=NN_last
#FLUX: --output=output/NN_last.out
#FLUX: --ntasks=5
#FLUX: --nodes=1
#FLUX: --time-limit=20h

module purge
#module load tensorflow/1.5-cpu-python-3.6.2
module load tensorflow/1.5-gpu-python-3.6.2


for drop in 0 0.1 0.2 0.25 0.3 0.4 0.7
do
	for N in 700
	do
		for nhidden in 0 1 2 3 4 5 6
		do
			for act in relu
			do
				for folder in 03-01-201911.04
				do
					for func in group_period_x_group_period group_period_2x2 atomic_number
					do
						python3 NN/NN_script.py $drop 700 relu $nhidden 03-01-2019\ 11.04 $func
					done
				done
			done
		done
	done
done

