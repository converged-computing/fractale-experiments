#!/bin/bash
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --time-limit=1d12h
#FLUX: --gpus-per-task=1


source ~/.bashrc
conda activate osmi
#pip install --user  -r ../requirements.py
#conda install grpcio
cd /project/bii_dsc_community/osmibench/code/osmi-bench/benchmark
singularity run --nv --home `pwd` ../tensorflow-serving_latest.sif tensorflow_model_server --port=8500 --rest_api_port=0 --model_config_file=models.conf >& log &
sleep 12
nvidia-smi
python tfs_grpc_client.py -m small_lstm -b 32 -n 48 localhost:8500
