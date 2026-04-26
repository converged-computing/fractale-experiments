#!/bin/bash
##Kør på gpu
#FLUX: --queue=gpuv100
##Antal gpuer vi vil bruge. Kommenter ud hvis cpu.
#FLUX: --gpus-per-node=1

##Navn på job
#FLUX: --job-name=NN_03-01
##Output fil
#FLUX: --output=output/NN_03-01-{id}.out
##Antal kerner
#FLUX: --ntasks=5
##Om kernerne må være på forskellige computere
#FLUX: --nodes=1
##Hvor lang tid må den køre hh:mm
#FLUX: --time-limit=20h

# The LSF memory request (-R "rusage[mem=6GB]") has no direct equivalent in flux-submit.
# The job may be scheduled on a node without enough memory (30GB total was requested).
# The LSF email notification flags (-B, -N) have no direct equivalent in flux-submit.


module purge
#module load tensorflow/1.5-cpu-python-3.6.2
module load tensorflow/1.5-gpu-python-3.6.2


for drop in 0.2 0.25 0.3 0.4
do
	for N in 250 350 400 450 550
	do
		for nhidden in 6
		do
			for act in sigmoid
			do
				for folder in 03-01-2019\ 11.04 09-01-2019\ 12.57 11-10-2018\ 11.36
				do
					for func in group_period_x_group_period group_period_2x2 atomic_number
					do
						python3 NN/NN_script.py $drop $N sigmoid 6 $folder $func
					done
				done
			done
		done
	done
done
