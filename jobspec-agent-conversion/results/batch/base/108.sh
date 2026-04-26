#!/bin/bash
#FLUX: --bank=yqs@v100
#FLUX: --job-name=TravailGPU
#FLUX: --requires=v100-32g
#FLUX: --queue=qos_gpu-t3
#FLUX: --output=TravailGPU{id}.out
#FLUX: --error=TravailGPU{id}.err
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --gpus-per-task=1
#FLUX: --cores-per-task=10
#FLUX: --time-limit=20h

# The SLURM '--hint=nomultithread' directive has no direct Flux analog.

module purge # nettoyer les modules herites par defaut
module load pytorch-gpu/py3/1.10.1 # charger les modules

# The srun command is not needed for a single-task job in Flux.
python -u train_gym.py #OVERRIDE IN CONFIG
#python -u train_dm_custom.py #upright # executer son script
