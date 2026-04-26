#!/bin/bash
#FLUX: --job-name=5_bert
#FLUX: --ntasks=1
#FLUX: --nodes=1
#FLUX: --time-limit=8h
#FLUX: --output=./5_wnut.o
#FLUX: --error=./5_wnut.e
#FLUX: --cores-per-task=8
#FLUX: --gpus-per-task=1
#FLUX: --cwd=/scratch/zt2080/shizhe/eres/BERT-NER-Pytorch-master

python run_ner_softmax.py --model_type=bert\
    --model_name_or_path=bert-base-cased\
    --learning_rate=5e-5\
    --num_train_epochs=30.0\
    --task_name=wnut_5\
    --data_dir=datasets/wnut\
    --per_gpu_train_batch_size=12\
    --per_gpu_eval_batch_size=32\
    --use_wandb\
    --cuda=0\
    --train_limit=1000000\
    --eval_limit=100000\
    --test_limit=100000\


