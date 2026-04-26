#!/bin/bash

#FLUX: --job-name=nerve-mrcnn
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=1
#FLUX: --time-limit=24h
#FLUX: --gpus-per-task=1

module purge
unset XDG_RUNTIME_DIR
if [ "$FLUX_JOB_TMPDIR" != "" ]; then
    export XDG_RUNTIME_DIR=$FLUX_JOB_TMPDIR
fi

singularity exec --nv /beegfs/work/public/singularity/cuda-9.0-cudnn7-devel-ubuntu16.04.simg bash -c "source /home/jtb470/.bashrc && conda activate nerve-mrcnn && python tools/train_net.py --config-file 'configs/nerve-101.yaml' OUTPUT_DIR final"
