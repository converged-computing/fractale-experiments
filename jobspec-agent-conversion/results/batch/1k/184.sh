#!/bin/bash
#FLUX: --gpus-per-node=1
#FLUX: --time-limit=3h


# set up environment
module load python
module list
source /path/to/your/env/bin/activate

# run benchmarking script
python cifar10_resnet.py --max_epochs 50 --n_jobs 1 --batch_size 2000
