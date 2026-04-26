#!/usr/bin/zsh

#FLUX: --nodes=1
#FLUX: --gpus-per-node=2
#FLUX: --ntasks=1
#FLUX: --cores-per-task=16
#FLUX: --time-limit=24h
#FLUX: --job-name=MPI_JOB
#FLUX: --output=output.txt

### end of Slurm SBATCH definitions

### beginning of executable commands

# Activate the Conda environment
source /home/mr634151/miniconda3/bin/activate
conda activate pytorch4sam

# Run your PyTorch distributed training
python UnetPlusSamPredictor.py
# python -m torch.distributed.launch --nproc_per_node=2 train.py

