#!/bin/sh
# The --partition, --account, --mail-user, and --mail-type directives are ignored.
#FLUX: --time-limit=5h
#FLUX: --gpus-per-task=1
#FLUX: --nodes=1
#FLUX: --ntasks=1
# The --mem=20000 directive has no direct flux analog and is omitted.
#FLUX: --job-name="road_detector"
#FLUX: --output=srun.out

# The SLURM_SUBMIT_DIR variable is replaced by FLUX_JOB_CWD
WORKDIR=${FLUX_JOB_CWD}
cd ${WORKDIR}

# Slurm environment variables are replaced with their Flux equivalents.
echo "we are running from this directory: $FLUX_JOB_CWD"
echo " the name of the job is: $FLUX_JOB_NAME"
echo "The job ID is $FLUX_JOB_ID"
echo "The job was run on these nodes: $FLUX_JOB_NODELIST"
echo "Number of nodes: $FLUX_JOB_NNODES"
echo "We are using $FLUX_JOB_NCORES cores"
echo "We are using $FLUX_JOB_NCORES cores per node"
echo "Total of $FLUX_JOB_NTASKS cores"

module purge
module load fosscuda/2020b
module load Anaconda3/2020.07
nvidia-smi
PYTHONPATH=/cluster/home/jorgro/road-detector python ./tools/train.py ./configs/road_detector.py --work-dir ./runs
uname -a
