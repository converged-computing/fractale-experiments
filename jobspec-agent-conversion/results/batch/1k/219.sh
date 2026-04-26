#!/bin/sh


#
# use gpu nodes
#FLUX: --mem-per-cpu=12000

# time consumption HH:MM:SS
#FLUX: --time-limit=4d4h30m

# name for script
#FLUX: --job-name=univ_alphastable_multi_ABC_dnn_small2

# controll job outputs
#FLUX: --output=lunarc_output/univaralphastable/outputs_alphastable_multiple_ABC_dnn_small_%j.out
#FLUX: --error=lunarc_output/univaralphastable/errors_alphastable_multiple_ABC_dnn_small_%j.err

# NOTE: The %j format specifier is not supported in Flux; files will be overwritten.


# we need to load the cuda stuff here!

# load modules

ml load GCC/6.4.0-2.28
ml load OpenMPI/2.1.2
ml load julia/1.0.0

# set correct path
pwd
cd ..
pwd

# run program
julia /home/samwiq/'ABC and deep learning project'/abc-dl/src/'alpha stable dist'/multiple_ABC_runs_mlp.jl mlp standard 250 100 100 50 2 0 large
