#!/bin/sh
#FLUX: --queue=GPUQ
#FLUX: --bank=ie-idi
#FLUX: --time-limit=5h
#FLUX: --gpus-per-node=1
#FLUX: --nodes=1
#FLUX: --ntasks-per-node=1
#FLUX: --job-name="road_detector"
#FLUX: --output=srun.out

# The SLURM --mem directive has no direct Flux analog in the provided documentation.
# The SLURM --mail-user and --mail-type directives have no direct Flux analog.

# Flux jobs start in the submission directory by default.
WORKDIR=$(pwd)
cd ${WORKDIR}
echo "we are running from this directory: $(pwd)"
echo " the name of the job is: $FLUX_JOB_NAME"
echo "The job ID is $FLUX_JOB_ID"
echo "The job was run on these nodes: $FLUX_JOB_NODELIST"
echo "Number of nodes: $FLUX_JOB_NNODES"
echo "We are using $FLUX_CPUS_ON_NODE cores"
echo "We are using $FLUX_CPUS_ON_NODE cores per node"
echo "Total of $FLUX_NTASKS cores"

module purge
module load fosscuda/2020b
module load Anaconda3/2020.07
nvidia-smi
PYTHONPATH=/cluster/home/jorgro/road-detector python ./tools/train.py ./configs/road_detector.py --work-dir ./runs
uname -a
