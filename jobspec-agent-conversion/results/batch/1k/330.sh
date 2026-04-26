#!/bin/bash -l
#FLUX: --ntasks-per-node=2
#FLUX: --ntasks=2
#FLUX: --time-limit=24h
#FLUX: --gpus-per-node=1
#FLUX: --job-name=FAU-FAPS

source /home/hpc/iwfa/iwfa018h/.bashrc
conda activate FAPS
# python trainer.py
#["Screw", "Sheet_Metal_Package", "Winding_Head", "Cable", "Cover"]
python main.py --model cvit --epochs ${epochs} --problem ${problem} --lr ${lr} --batch-size ${batch}

echo ${epochs}_${problem}_${lr}_${batch}

