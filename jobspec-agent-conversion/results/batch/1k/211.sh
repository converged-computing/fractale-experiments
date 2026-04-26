#!/bin/sh

#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --exclusive
#FLUX: --time-limit=10h
#FLUX: --job-name=ou_cpmmh_099_100
#FLUX: --output=lunarc_output/outputs_ou_cpmmh.out
#FLUX: --error=lunarc_output/errors_ou_cpmmh.err

# load modules

ml load GCC/6.4.0-2.28
ml load OpenMPI/2.1.2
ml load julia/1.0.0

# set correct path
pwd
cd ..
pwd

export JULIA_NUM_THREADS=1


# run program
julia /home/samwiq/'SDEMEM and CPMMH'/SDEMEM_and_CPMMH/src/'SDEMEM OU process'/run_script_cpmmh_for_plot_mess_vs_N.jl 100 0.99 300 # M_mixtures N_time nbr_particles correlation seed


