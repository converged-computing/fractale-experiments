#!/bin/bash
# The --account and --partition directives are ignored.
# The --mem=0 directive is the default behavior in Flux (use all node memory) and is omitted.
# The --ntasks=1 and --cpus-per-task=40 are interpreted as a single task with 40 cores.
# However, the torchrun command specifies nproc_per_node=4, which is a better indicator
# of the user's intent. The job will be configured for 4 tasks, each with 1 GPU and a share of the CPUs.
#FLUX: --nodes=1
#FLUX: --ntasks=4
#FLUX: --cores-per-task=10
#FLUX: --gpus-per-task=1
#FLUX: --time-limit=15m
# The --gres=gpu:v100:4 directive is translated to a gpu count and a constraint.
# The gpu count is handled by gpus-per-task, and the constraint is added below.
#FLUX: --requires=v100

module purge
module load pytorch

# Old way with torch.distributed.run
# flux mini run python3 -m torch.distributed.run --standalone --nnodes=1 --nproc_per_node=4 mnist_ddp.py --epochs=100

# New way with torchrun. `flux mini run` is used as the launcher.
flux mini run torchrun --standalone --nnodes=1 --nproc_per_node=4 mnist_ddp.py --epochs=100
