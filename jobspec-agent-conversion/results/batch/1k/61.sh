#!/bin/bash
#FLUX: --ntasks=1
#FLUX: --nodes=1
#FLUX: --time-limit=7d
#FLUX: --output=/n/home06/lsepulvedaduran/Software/merfish-parameters/slurm/out/BC071_sample_02_nuc_seg.out
#FLUX: --error=/n/home06/lsepulvedaduran/Software/merfish-parameters/slurm/err/BC071_sample_02_nuc_seg.err

# The --mem 4000 directive has no direct analog in the provided flux submit options.
# This may impact job scheduling and resource allocation.
# The --open-mode=append directive has no direct analog in Flux; output files will be truncated.

date +'Starting at %R.'

source centos7-modules.sh
module load Anaconda3/5.0.1-fasrc01
source activate merlin_env
module load gcc/8.2.0-fasrc01
module load fftw
which python
echo BC071_sample_02

merlin -k snakemake_parameters.json \
       -a merlin_analysis_BC071_nuclei_segmentation.json \
       -o data_organization_BC071_3.csv \
       -p positions_BC071_sample_02.txt \
       -c C1E1_codebook.csv \
       -m MERFISH3.json \
       -n 1000 \
       191212_BC071_MERFISH/sample_02

date +'Finished at %R.'
