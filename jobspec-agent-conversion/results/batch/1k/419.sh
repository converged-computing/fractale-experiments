#!/bin/bash
#FLUX: --time-limit=16h
# The -n 8 and -R "span[ptile=8]" directives are interpreted as a request for a single node with 8 cores.
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=8
# The -M 48000 (memory) directive has no direct flux analog and is omitted.
#FLUX: --error=logs/train_scratch%j.err
#FLUX: --output=logs/train_scratch%j.out
# The -q amdgpu (queue) directive is ignored as per instructions.
#FLUX: --gpus-per-task=1

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
