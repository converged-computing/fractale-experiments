#!/bin/bash
##Kør på gpu
#FLUX: --gpus-per-task=1

##Navn på job
#FLUX: --job-name=NN_last
##Output fil
#FLUX: --output=output/NN_last-%J.out
##Antal kerner
#FLUX: --ntasks=1
#FLUX: --cores-per-task=5
##Om kernerne må være på forskellige computere
#FLUX: --nodes=1
##Hvor lang tid må den køre hh:mm
#FLUX: --time-limit=20h


module purge
#module load tensorflow/1.5-cpu-python-3.6.2
module load tensorflow/1.5-gpu-python-3.6.2


for drop in 0 0.1 0.2 0.25 0.3 0.4 0.7
do
	for N in 550
	do
		for nhidden in 0 1 2 3 4 5 6
		do
			for act in sigmoid
			do
				for folder in 03-01-2019\ 11.04 09-01-2019\ 12.57 11-10-2018\ 11.36
				do
					for func in group_period_x_group_period group_period_2x2 atomic_number
					do
						python3 NN/NN_script.py $drop 550 sigmoid $nhidden $folder $func
					done
				done
			done
		done
	done
done
