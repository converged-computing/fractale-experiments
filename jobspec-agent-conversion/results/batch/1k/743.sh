#!/bin/bash

for strength in "0.3"
do
for prior in "2e-3"
do
for var in "$@"
do
flux submit <<EOT
#!/bin/bash
#FLUX: --ntasks=1
#FLUX: --cores-per-task=1
#FLUX: --job-name=prior-$var-gt-edge_pruning
#FLUX: --gpus-per-task=1
#FLUX: --time-limit=12h
#FLUX: --output=prog_files/gtprio-pre_$var.out
#FLUX: --error=prog_files/gtprio-pre_$var.err

# Your commands here
module load Anaconda2
conda activate take2
python3 edge_pruning_vertex_gt_prior.py --lamb $var --prior $prior --strength $strength

EOT
done
done
done
