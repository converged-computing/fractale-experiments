#!/bin/bash
#FLUX: --job-name=job_wgpu
# The --open-mode=append directive has no direct flux analog and is omitted.
#FLUX: --output=./%j_%x.out
#FLUX: --error=./%j_%x.err
# The --export=ALL directive is the default behavior in flux and is omitted.
#FLUX: --time-limit=10m
#FLUX: --gpus-per-task=1
# The --mem=64G directive has no direct flux analog and is omitted.
#FLUX: --ntasks=1
#FLUX: --cores-per-task=4

singularity exec --nv --overlay $SCRATCH/overlay-50G-10M.ext3:ro /scratch/work/public/singularity/cuda10.1-cudnn7-devel-ubuntu18.04-20201207.sif /bin/bash -c "

source /ext3/env.sh
conda activate

python ./test_gpu.py
"
