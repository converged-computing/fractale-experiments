#!/bin/bash
#FLUX: --cores=8
#FLUX: --nodes=1
#FLUX: --gpus-per-node=4
#FLUX: --time-limit=24h

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/cuda/10.0/lib64:/opt/cudnn/cuda-10.0/7.3/cuda/lib64
source activate /bos/usr0/zhuyund/tf_env 
export BERT_BASE_DIR=/bos/usr0/zhuyund/uncased_L-12_H-768_A-12
export INIT_CKPT=./output/marco/model.ckpt-65816
export TEST_DATA_FILE=./data/collection.tsv.1
export OUTPUT_DIR=./output/marco/collection_pred_1/

python run_deepct.py \
  --task_name=marcotsvdoc \
  --do_train=false \
  --do_eval=false \
  --do_predict=true \
  --data_dir=$TEST_DATA_FILE \
  --vocab_file=$BERT_BASE_DIR/vocab.txt \
  --bert_config_file=$BERT_BASE_DIR/bert_config.json \
  --init_checkpoint=$INIT_CKPT \
  --max_seq_length=128 \
  --train_batch_size=16 \
  --learning_rate=2e-5 \
  --num_train_epochs=3.0 \
  --output_dir=$OUTPUT_DIR
