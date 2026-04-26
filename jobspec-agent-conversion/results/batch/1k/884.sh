#!/bin/bash
#FLUX: --time=1h
#FLUX: --nodes=1
#FLUX: --tasks-per-node=1
#FLUX: --ntasks=1
#FLUX: --gpus-per-task=4
#FLUX: --cpus-per-task=96
# Job name
#FLUX: --job-name=find_lr

# Output and error logs
#FLUX: --output=logs_slurm/log_%x_%j.out
#FLUX: --error=logs_slurm/log_%x_%j.err

# NOTE: The %x and %j format specifiers are not supported in Flux; files will be overwritten.


# Add jobscript to job output
echo "#################### Job submission script. #############################"
cat $0
echo "################# End of job submission script. #########################"

module purge
module load GCC/10.3.0 CUDA/11.0 cuDNN/8.0.2.39-CUDA-11.0
export CUDA_VISIBLE_DEVICES=0,1,2,3
jutil env activate -p prcoe12
nvidia-smi

source /p/project/prcoe12/wulff1/miniconda3/bin/activate tf2
echo "Python used:"
which python3
python3 --version


python3 tf_list_gpus.py

CUDA_VISIBLE_DEVICES=0,1,2,3 python3 mlpf/pipeline.py find-lr -c $1

# cp lr_finder.jpg $SLURM_SUBMIT_DIR/
