#!/bin/bash
#FLUX: --nodes=1
#FLUX: --gpus-per-node=20
#FLUX: --cores-per-task=1
#FLUX: --ntasks=1
#FLUX: --time-limit=10h
#FLUX: --job-name=morphot_parallel_benchmark
#FLUX: --output=output.txt
#FLUX: --error=output.txt
#FLUX: --cwd=.

################################################################################

module load gcc cuda python3 py-pip/19.0.3-py3.7.3 openblas py-scipy parallel


nvidia-smi >> gpuinfo.txt
lscpu >> cpuinfo.txt

source ../venv/bin/activate

parallel 'python3 simconv.py -fn 25 -it {1} -ds 1 -reg {2} -i1 data/3iyf.mrc -i2 data/3los.mrc --outdir . --cuda' ::: 50 100 200 ::: 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2 2.1 2.2 2.3 2.4 2.5 2.6 2.7 2.8 2.9 3 3.1 3.2 3.3 3.4 3.5 3.6 3.7 3.8 3.9 4


