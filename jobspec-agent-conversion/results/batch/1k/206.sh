#!/bin/bash
#FLUX: --nodes=1
#FLUX: --cores-per-task=1
#FLUX: --time-limit=48h
#FLUX: --gpus-per-task=1
#FLUX: --job-name=PTB_pipe
#FLUX: --output=logs/ptb_pipe.out

# The --mem=100GB directive has no direct analog in the provided flux submit options.
# This may impact job scheduling and resource allocation.
# The partition and mail directives were ignored as per instructions.


# configuration type to select in config.yml
# if not defined, will use the default configuration
CONFIG='small_nets'


# load required modules
module purge
module load tensorflow/python3.5/1.2.1 cuda/8.0.44

cd hierarchical-rnn
# train on Text8 dataset
python3 -u char_class.py --config $CONFIG > logs/char_class.log
# test on Penn Treebank
python3 -u ptb_test.py --config $CONFIG > logs/ptb_test.log

# backup generated tensorflow models
TIMESTAMP=$(date +%Y%m%d%H%M%S)
mkdir -p ../backup/$TIMESTAMP
cp logs/char_class.log checkpoint text8.[dim]* ../backup/$TIMESTAMP/

# evaluate boundary indicators by PTB as benchmark
cd ../treebank
python3 evaluate.py > logs/ptb_eval.log
