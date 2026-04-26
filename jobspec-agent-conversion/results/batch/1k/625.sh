#! /bin/bash --login
#FLUX: --nodes=1
# The -G uiuc (project) and -q pbatch (queue) directives are ignored.
#FLUX: --time-limit=12h
#FLUX: --job-name=mirge_Y0
#FLUX: --output=runOutput.%j
#FLUX: --error=runError.%j

# The jsrun command's resource specification is translated to flux directives below
# jsrun -g 1 -> --gpus-per-task=1
# jsrun -a 1 -> This is a resource-set allocation, which is complex. Assuming 1 task per resource-set.
# jsrun -n 1 -> --ntasks=1
# The most direct translation is a single task with one GPU.
#FLUX: --gpus-per-task=1
#FLUX: --ntasks=1

module load gcc/7.3.1
module load spectrum-mpi
conda deactivate
conda activate mirgeDriver.Y1nozzle
export PYOPENCL_CTX="port:tesla"
#export PYOPENCL_CTX="0:2"

# The jsrun command is replaced by `flux mini run`
export XDG_CACHE_HOME="/tmp/$USER/xdg-scratch"
flux mini run hostname # js_task_info is not a standard command, replaced with hostname
flux mini run python -u -m mpi4py ./nozzle.py
