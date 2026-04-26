#!/bin/bash
#FLUX: --ntasks=1
#FLUX: --cores-per-task=40
#FLUX: --nodes=1
#FLUX: --gpus-per-task=8
#FLUX: --time-limit=5h30m
#FLUX: --output=new_litllama.out
#FLUX: --error=new_litllama.err


# **** Put all #SBATCH directives above this line! ****
# **** Otherwise they will not be effective! ****

# **** Actual commands start here ****
# Load modules here (safety measure)
module purge
source ~/.bashrc
conda activate llamaenv
# You may need to load gcc here .. This is application specific
# module load gcc
# Replace this with your actual command. 'serial-hello-world' for example
# Set MP, set TARGET_FOLDER to the folder containing the model and tokenizer
#TARGETFOLDER = llamadownloads, 1 -> 7B, 2 -> 13B, 4 -> 30B, 8 -> 65B
python lit-llama/scripts/convert_checkpoint.py --checkpoint_dir "litllamadata/" --model_size 65B
