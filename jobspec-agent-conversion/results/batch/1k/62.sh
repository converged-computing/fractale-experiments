#!/bin/bash
#FLUX: --job-name=ezCGP_simgan
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=8
#FLUX: --gpus-per-task=1
#FLUX: --time-limit=5d8h
#FLUX: --output=simgan.out

echo "Started on `/bin/hostname`" # prints name of compute node job was started on

nvidia-smi

if [ -z "$1" ]
then
      setseed=""
else
      setseed="--seed $1"
fi

if [ -z "$2" ]
then
      setprevrun=""
else
      setprevrun="--previous_run $2"
fi

cd ~/ezCGP
module load anaconda3/2020.02
module load cuda/10.1
conda activate simgan-cgp
rm -rf ~/.nv
python main.py -p problem_simgan_ecg -v $setseed $setprevrun
