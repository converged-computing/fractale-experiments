#! /bin/bash
#FLUX: --gpus-per-node=2
#FLUX: --nodes=1
#FLUX: --ntasks=4
#FLUX: --time-limit=5d
#FLUX: --output=/scratch/yaoy4/log/test-random-list13.log

setpkgs -a tensorflow_0.12

python  /scratch/yaoy4/BodySegmentation/run.py train random 13
python  /scratch/yaoy4/BodySegmentation/run.py train random 13
python  /scratch/yaoy4/BodySegmentation/run.py train random 13
python  /scratch/yaoy4/BodySegmentation/run.py train random 13
python  /scratch/yaoy4/BodySegmentation/run.py train random 13
python  /scratch/yaoy4/BodySegmentation/run.py train random 13
python  /scratch/yaoy4/BodySegmentation/run.py train random 13
