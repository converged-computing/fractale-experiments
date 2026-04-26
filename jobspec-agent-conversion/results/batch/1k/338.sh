#!/bin/bash
#FLUX: --ntasks=1
#FLUX: --gpus-per-task=1
#FLUX: --cores-per-task=6
#FLUX: --time-limit=10h

nvidia-smi

#module load python/3.6 cuda cudnn

SOURCEDIR=/scratch/aarti9

# Prepare virtualenv
#source ~/vgaf_env/bin/activate
# You could also create your environment here, on the local storage ($SLURM_TMPDIR), for better performance. See our docs on virtual environments.

# Prepare data
#mkdir $SLURM_TMPDIR/data
#tar xf ~/projects/def-xxxx/data.tar -C $SLURM_TMPDIR/data

pip install --no-index --upgrade pip

pip install --no-index -r requirements.txt

# Start training
python $SOURCEDIR/vgaf_PP_Val_16F.py
