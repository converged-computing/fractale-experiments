#!/bin/bash

#FLUX: --job-name=balanced
#FLUX: --nodes=2
#FLUX: --ntasks-per-node=2
#FLUX: --ntasks=4
#FLUX: --cores-per-task=2
#FLUX: --time-limit=4d
#FLUX: -o ./slurmouts/balanced_%j.out


# NOTE: The %j format specifier is not supported in Flux; files will be overwritten.

module purge


drugs=(Atezo Pembro Nivo)

# NOTE: This script is a job array. The SLURM_ARRAY_TASK_ID variable has been
# replaced with FLUX_JOB_CC. You must submit this job with 'flux submit --cc=0-2 ...'
singularity exec --nv \
            --overlay /scratch/jjb509/GeneExpression_Bakeoff/src/my_overlay.ext3:ro \
            /scratch/work/public/singularity/cuda11.6.124-cudnn8.4.0.27-devel-ubuntu20.04.4.sif\
            /bin/bash -c "source /ext3/env.sh; python model_comparison.py -drug ${drugs[$FLUX_JOB_CC]} -balance 1"
