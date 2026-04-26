#!/bin/bash
#FLUX: --time-limit=10m
#FLUX: --job-name=qmc_units_test
#FLUX: --ntasks=1
#FLUX: --cores-per-task=2
#FLUX: --output=qmc_units_test-%J.out


# NOTE: The %J format specifier is not supported in Flux; files will be overwritten.

module purge

module load julia/1.8.5 StdEnv/2020

# cd to qmc_test dir
# sbatch qmc.sh
julia rydberg_bloqade_ver.jl thermal 16 /home/hpcfung/qmc_test --omega 26.6407057024 --delta -1.545 --radius 1.15 --rand-slice --restart

echo 'qmc program completed'
