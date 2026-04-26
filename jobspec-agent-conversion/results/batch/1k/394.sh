#! /usr/bin/env bash
#
#FLUX: --job-name=ngon
#FLUX: --output=ngon_%A-%a_out.txt
#FLUX: --error=ngon_%A-%a_err.txt
#
#FLUX: -n 1
#FLUX: -t 5m
#FLUX: --cc=1-6

# The SLURM directive '--mem-per-cpu=1G' was omitted as it has no direct Flux translation.
# The filename substitutions %A and %a are not supported by Flux and will be treated literally.

# load modules
module load python/3.8.5

# move to the directory where the script/data are
#cd 

data_file='input_data.txt'

# read the i-th line of the data file (where i is the array number)
# and stor it as "n"
# Translated SLURM_ARRAY_TASK_ID to FLUX_JOB_CC
n=$(sed -n ${FLUX_JOB_CC}p ${data_file})

echo "I'm array job number ${FLUX_JOB_CC}"
echo "My n-gon number is ${n}"

python3 paralProg/area_of_ngon.py --out ${n}-gon.txt ${n}

