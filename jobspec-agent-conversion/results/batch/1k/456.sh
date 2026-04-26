#!/bin/bash
#FLUX: --time-limit=2h
#FLUX: --job-name=spike_train

# NOTE: alloc_flags "NVME" is not supported.

# Load modules
module load gcc/7.4.0
module load python/3.6.6-anaconda3-5.3.0
module load cuda/10.1.243
module load hdf5/1.10.4

# activate env
#source activate /gpfs/alpine/proj-shared/med110/atrifan/scripts/pytorch-1.6.0_cudnn-8.0.2.39_nccl-2.7.8-1_static_mlperf
source activate /ccs/home/tkurth/project/pytorch/pytorch-1.6.0_cudnn-8.0.2.39_nccl-2.7.8-1_py-3.6_static_mlperf

# run tag
wandb_token=6c8b9db0b520487f05d32ebc76fcea156bd85d58

# NOTE: The node count is determined at runtime, which is unusual.
# You may want to add a '--nodes' directive to the script.
nnodes=$(flux resource list | wc -l)
run_tag="cmaps-spike-summit-2-nnodes${nnodes}"


# launch job
# jsrun is replaced with 'flux run'. Detailed binding flags are not translated.
# The resource allocation will be different from the original script.
flux run -n ${nnodes} --gpus-per-task=6 --cores-per-task=42 \
    ./run_vae_dist_summit.sh ${wandb_token} ${run_tag}
