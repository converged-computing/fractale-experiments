#! /bin/bash --login
#FLUX: --nodes=1
#FLUX: --bank=uiuc
#FLUX: --time-limit=12h
#FLUX: --job-name=mirge_Y0
#FLUX: --queue=pbatch
#FLUX: --output=runOutput.{id}
#FLUX: --error=runError.{id}
#FLUX: --ntasks=1
#FLUX: --gpus-per-task=1

module load gcc/7.3.1
module load spectrum-mpi
conda deactivate
conda activate mirgeDriver.Y1nozzle
export PYOPENCL_CTX="port:tesla"
#export PYOPENCL_CTX="0:2"

# The jsrun command has been replaced with 'flux mini run'.
# The js_task_info command may not be available in a non-jsrun environment.
flux_run_cmd="flux mini run -n 1 -g 1"

export XDG_CACHE_HOME="/tmp/$USER/xdg-scratch"
$flux_run_cmd js_task_info
$flux_run_cmd python -u -m mpi4py ./nozzle.py
