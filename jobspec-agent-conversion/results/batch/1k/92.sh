#!/bin/bash

#FLUX: --job-name=AD_freq2
#FLUX: --output=AD_freq2.out
#FLUX: --error=AD_freq2.err
#FLUX: --time-limit=2d
#FLUX: --nodes=1
#FLUX: --tasks-per-node=28
#FLUX: --ntasks=28


ml easybuild GCC/6.3.0-2.27 OpenMPI/2.0.2 Python/3.6.1
pip list installed | grep numpy

python part2FreqDist.py -f1 22_3H_both_S16_L008_R1_001.fastq  -f2 22_3H_both_S16_L008_R2_001.fastq  \
-f3 32_4G_both_S23_L008_R1_001.fastq -f4 32_4G_both_S23_L008_R2_001.fastq
