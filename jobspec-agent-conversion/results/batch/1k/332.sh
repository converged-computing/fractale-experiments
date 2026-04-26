#!/bin/sh
# altai_demo.sh
# Torque script to run GPU-optimized Altai pipeline on spontaneous zebrafish data.

#FLUX: --job-name=altai_demo
#FLUX: --time-limit=24h
#FLUX: --gpus-per-task=2
#FLUX: --ntasks=1
#FLUX: --output=/vega/stats/users/dbp2112/ahrens/results/altai_demo.out
#FLUX: --error=/vega/stats/users/dbp2112/ahrens/results/altai_demo.err

echo $RNG
if [[ -z "$RNG" ]]; then
	matlab-R2012b -nosplash -nodisplay -nodesktop -r "demo" > matoutfile
else
	matlab-R2012b -nosplash -nodisplay -nodesktop -r "tRng = $RNG; demo" > matoutfile
fi

#End of script

