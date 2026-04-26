#!/bin/bash
#FLUX: --job-name=job_wgpu
#FLUX: --output=./{id}_{job-name}.out
#FLUX: --error=./{id}_{job-name}.err
#FLUX: --time-limit=10m
#FLUX: --ntasks=1
#FLUX: --gpus-per-task=1
#FLUX: --cores-per-task=4

# The SLURM --mem directive has no direct Flux analog in the provided documentation.
# The SLURM --open-mode=append directive has no direct Flux analog.
# The SLURM --export=ALL directive is assumed as default behavior.

singularity exec --nv --overlay $SCRATCH/overlay-50G-10M.ext3:ro /scratch/work/public/singularity/cuda10.1-cudnn7-devel-ubuntu18.04-20201207.sif /bin/bash -c "

source /ext3/env.sh
conda activate

python ./test_gpu.py
"
