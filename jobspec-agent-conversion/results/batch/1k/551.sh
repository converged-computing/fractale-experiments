#!/bin/bash 
#FLUX: --nodes=3
#FLUX: --tasks-per-node=2
#FLUX: --cores-per-task=1
#FLUX: --time-limit=2h
#FLUX: --gpus-per-node=1
#FLUX: --ntasks=6


module purge

singularity exec --nv \
	    --overlay /scratch/nn1331/whisper/whisper.ext3:ro \
            /scratch/work/public/singularity/cuda11.6.124-cudnn8.4.0.27-devel-ubuntu20.04.4.sif\
	    /bin/bash -c "source /ext3/env.sh; python whisper.py"
