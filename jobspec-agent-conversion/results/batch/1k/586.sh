#!/bin/bash
#FLUX: --ntasks=1
#FLUX: --gpus-per-task=1
#FLUX: --cores-per-task=4
#FLUX: --time-limit=10h
#FLUX: --job-name=Benchmark
#FLUX: --output=Benchmark


module purge
singularity exec --nv \
            --overlay /scratch/tn2151/pytorch-example/overlay-10GB-400K.ext3:ro \
            /scratch/work/public/singularity/cuda11.6.124-cudnn8.4.0.27-devel-ubuntu20.04.4.sif\
            /bin/bash -c "source /ext3/env.sh;
        python main_DP.py;"
