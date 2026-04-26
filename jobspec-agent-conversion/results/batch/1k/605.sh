#!/bin/bash 

## Job Name 
#FLUX: --job-name=XXX

## Resources 
## Nodes 
#FLUX: --nodes=1

## GPUs 
#FLUX: --gpus-per-node=XX
#FLUX: --requires=q6000

## Tasks per node (Slurm assumes you want to run 28 tasks, remove 2x # and adjust parameter if needed)
#FLUX: --ntasks-per-node=XX 

## Walltime (ten minutes) 
#FLUX: --time-limit=XX 

## Memory per node - NO DIRECT ANALOG IN FLUX
# The --mem=40G directive has no direct analog in the provided flux submit options.

## Specify the working directory for this job 
#FLUX: --cwd=XXX

# The account, partition, and mail-type directives were ignored as per instructions.

# Load cuda 11.1
module load cuda/11.1.1-1

# Load c++ compiler
module load gcc/10.1.0

# Load cmake 
module load cmake/3.11.2

# Load gromacs 2020.5
source /gscratch/pfaendtner/jpfaendt/codes/gmx2020.5/bin/GMXRC

# Execute mdrun 
gmx mdrun -nt XX -gpu_id X -nb gpu -pme cpu -cpi restart -cpo restart -cpt 1.0 &> log.txt
