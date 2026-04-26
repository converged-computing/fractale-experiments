#!/bin/bash
#FLUX: --job-name=laplace
#FLUX: --ntasks=1
#FLUX: --time-limit=1h30m
#FLUX: --cores-per-task=40
#FLUX: --output=%x.%j.out
#FLUX: --error=%x.%j.err


echo "*** SEQUENTIAL LAPLACE EQUATION GRID 1000X1000 ***"
# srun is not required for a single task job in Flux
singularity run container.sif laplace_seq_it 1000
echo " "
echo "*** PTHREAD LAPLACE EQUATION grid 1000x1000 ***"
for i in 1 2 5 10 20 40
do
	echo "*** Parallel algorithm with $i threads ***"
	# srun is not required for a single task job in Flux
	singularity run container.sif laplace_pth_it 1000 $i
	echo " "
done
