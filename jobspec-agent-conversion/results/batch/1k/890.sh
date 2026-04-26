#!/bin/bash
#
#FLUX: --job-name=news_adj_poly
#FLUX: --nodes=1
#FLUX: --ntasks-per-node=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=1
#FLUX: --output=runs/outputs/polyjuice_news_random_adj.out.log
#FLUX: --error=runs/errors/polyjuice_news_random_adj.error.log
#FLUX: --time-limit=4d
#FLUX: --gpus-per-task=1



cd /users/pa21/ptzouv/tkaravangelis/mice
module purge
module load gnu/8 cuda/10.1.168 intelmpi/2018 pytorch/1.7.0
source /users/pa21/ptzouv/tkaravangelis/venv_polyjuice/bin/activate

start=$(date +%s.%N)
# srun is not required for a single task job in Flux
python ../scripts/polyjuice_newsgroups.py ADJ
deactivate

end=$(date +%s.%N)
runtime=$( echo "$end - $start" | bc -l )
echo "Total script time $runtime"
