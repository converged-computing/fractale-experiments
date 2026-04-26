#!/bin/bash
#FLUX: --nodes=1
#FLUX: --ntasks-per-node=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=48
#FLUX: --time-limit=48h
#FLUX: --job-name=evopcgrl
#FLUX: --output=evo_runs/evopcg_0.out
#FLUX: --cwd=/scratch/zj2086/control-pcgrl


## Is this actually necessary?
source activate

## NOTE THIS ACTUALLY WORKS DONT LISTEN TO THE ERROR MESSAGE ???
conda activate pcgrl

start=$SECONDS
while ! python evo/evolve.py -la 0
do
    duration=$((( SECONDS - start ) / 60))
    echo "Script returned error after $duration minutes"
    if [ $duration -lt 60 ]
    then
      echo "Too soon. Something is wrong. Terminating node."
      exit 42
    else
      echo "Killing ray processes and re-launching script."
      ray stop
      pkill ray
      pkill -9 ray
      pkill python
      pkill -9 python
      start=$SECONDS
    fi
done

