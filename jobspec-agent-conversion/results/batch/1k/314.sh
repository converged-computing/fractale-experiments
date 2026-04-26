#!/bin/bash
#FLUX: --job-name=NN_last
#FLUX: --output=output/NN_last-%J.out
#FLUX: -n 5
#FLUX: -N 1
#FLUX: -t 20h
#FLUX: -g 1

# The LSF resource requirement for memory ('-R "rusage[mem=6GB]"') was omitted due to no direct translation.
# The LSF GPU exclusivity mode ('mode=exclusive_process') was omitted.
# The filename substitution %J is not supported by Flux and will be treated literally.
# Queue and mail directives were ignored as per instructions.

module purge
#module load tensorflow/1.5-cpu-python-3.6.2
module load tensorflow/1.5-gpu-python-3.6.2


for drop in 0 0.1 0.2 0.25 0.3 0.4 0.7
do
	for N in 600
	do
		for nhidden in 0 1 2 3 4 5 6
		do
			for act in relu
			do
				for folder in 03-01-201911.04
				do
					for func in group_period_x_group_period group_period_2x2 atomic_number
					do
						python3 NN/NN_script.py $drop 600 relu $nhidden 03-01-2019\ 11.04 $func
					done
				done
			done
		done
	done
done
