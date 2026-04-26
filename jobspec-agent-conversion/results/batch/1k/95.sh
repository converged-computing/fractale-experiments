#!/bin/bash
#FLUX: --nodes=64
#FLUX: --job-name=2048_acoustics
#FLUX: --output=2048_acoustics.out
#FLUX: --time-limit=3h

# The following resource requests are derived from the 'srun' command:
# --ntasks=2048 -> total tasks
# --cpus-per-task=1 -> cores per task
# --ntasks-per-node=32 -> tasks per node
#FLUX: --ntasks=2048
#FLUX: --tasks-per-node=32
#FLUX: --cores-per-task=1

# The following srun affinity hints do not have direct analogs in Flux:
# --hint=nomultithread
# --ntasks-per-socket=16
# --cpu_bind=cores

echo job running on...
hostname

module load python/.pyclaw_64bits_493

export OMP_NUM_THREADS=1
export PYTHONPATH=/project/k1069/lib/python2.7/site-packages:$PYTHONPATH

# The srun command has been replaced with flux run. Resource allocation
# is now handled by the #FLUX directives above.
flux run python ../acoustics_3d_scaling.py -s strong -x 256 use_petsc=1
