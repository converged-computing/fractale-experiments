#FLUX: --job-name=job_6_ans-1000_a
#FLUX: --time-limit=5h
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --gpus-per-task=1
#FLUX: --cores-per-task=2
#FLUX: --cwd=.

## SPECIFY JOB NOW

JOBNAME=HPRSR
CURTIME=$(date +%Y%m%d%H%M%S)
##module load apps/pythonpackages/3.6.0/pytorch/0.4.1/gpu
##module load apps/anaconda3/4.6.9
## Change to dir from where script was launched
##conda activate tr3



bash exp_6.sh

