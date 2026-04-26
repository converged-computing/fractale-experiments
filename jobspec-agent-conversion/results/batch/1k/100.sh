#!/bin/bash

#FLUX: --time-limit=7h59m59s
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=2
#FLUX: --output=job.out
#FLUX: --error=job.err

source /home/cough052/barna314/anaconda3/bin/activate nmma

python /panfs/roc/groups/7/cough052/barna314/nmma_fitter/nmma_fit.py --datafile "$1" --candname "$2" --model "$3" --dataDir "$4" --nlive 512 --cpus 2

