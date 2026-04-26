#! /bin/bash

#FLUX: --job-name=k40ts
#FLUX: --nodes=1
#FLUX: --cores=12
#FLUX: --gpus-per-node=1
#FLUX: --time-limit=24h

# The PBS memory request (-l mem=80gb) has no direct analog in the provided flux submit options.
# This may impact job scheduling and resource allocation.

cd /project/Training/DL/

module load cuda/8.0.44
module load openmpi-gcc/3.0.0-cuda
source mini/bin/activate DL3

#python timeserieslearn.py
python -c 'import tensorflow as tf; print(tf.__version__)'
python ts_100k.py
