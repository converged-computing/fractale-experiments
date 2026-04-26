#!/bin/bash
#FLUX: --time-limit=3d
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --tasks-per-node=1
#FLUX: --cores-per-task=16

export HOME=`getent passwd $USER | cut -d':' -f6`
export PYTHONUNBUFFERED=1
echo Running on $HOSTNAME

source /pl/active/ccnlab/conda/etc/profile.d/conda.sh
conda activate pytorch_mpi

export MKL_NUM_THREADS=16 OMP_NUM_THREADS=16

echo "MKL_NUM_THREADS: "
echo $MKL_NUM_THREADS
echo "OMP_NUM_THREADS: "
echo $OMP_NUM_THREADS

python train_test.py \
--results_dir train_results \
--out_data_file train_defaults.json \
--checkpoint_path ../model_weights/defaults.pt
