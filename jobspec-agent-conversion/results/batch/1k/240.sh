#!/bin/bash

# Source: https://stackoverflow.com/a/44168719
# Run using the following: bash trainFromConfig.sh <Config_Name>

flux submit <<EOT
#!/bin/bash
#FLUX: --output="train_${1}.log"
#FLUX: --job-name="train_${1}"
#FLUX: --gpus-per-task=1
#FLUX: --ntasks=1
#FLUX: --time-limit=16h

echo "The config file used is KWT_configs/${1}.cfg"
singularity exec --nv ~/pytorch-24.01 python train.py --conf "KWT_configs/${1}.cfg"
EOT
