#!/bin/bash
#FLUX: -t 16h
#FLUX: --nodes=1
#FLUX: --tasks-per-node=8
#FLUX: -q amdgpu
#FLUX: --gpus-per-node=1
#FLUX: --error=logs/train_scratch{flux:id}.err
#FLUX: --output=logs/train_scratch{flux:id}.out

# NOTE: The LSF directive '#BSUB -M 48000' for a memory limit was omitted as there is no direct Flux equivalent.
# This may cause the job to be scheduled on a node with insufficient memory.
# NOTE: The LSF directive '#BSUB -R "span[ptile=8]"' has been interpreted as a request for 8 tasks on a single node.

# load modules
module load bedtools/2.29.2-wrl
module load gcc/9.3.0
module load cuda/11.7
module load samtools/1.6-wrl
module load pigz/2.6.0
module load ucsctools
source activate maxatac

# the main command

cd /data/weirauchlab/team/ngun7t/maxatac/runs

maxatac train --genome hg38 \
--arch Transformer_phuc \
--sequence /users/ngun7t/opt/maxatac/data/hg38/hg38.2bit \
--meta_file /data/weirauchlab/team/ngun7t/maxatac/training_data/meta_file.tsv \
--output /data/weirauchlab/team/ngun7t/maxatac/runs/scratch \
--prefix scratch \
--epochs 1
