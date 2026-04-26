#!/bin/bash
#FLUX: --queue=h-debug
#FLUX: --nodes=2
#FLUX: --tasks-per-node=2
#FLUX: --cores-per-task=1
#FLUX: --bank=pz0xxx
#FLUX: --time-limit=15m

GROUP=$(id -ng)
MYDIR=/lustre/${GROUP}/${USER}
export HOME=$MYDIR

. $MYDIR/env.sh

cd $MYDIR

# デバッグ出力： Chainer と CuPy のバージョンを表示
python -c "import chainer; print(chainer.__version__)"
python -c "import cupy; print(cupy.cuda.nccl.get_version())"

# The mpiexec command has been replaced with flux run.
# Flux will automatically handle the environment and launch 4 tasks (2 nodes * 2 tasks/node).
flux run -n 4 --env=PYTHONUSERBASE \
        python ./train_mnist.py -g --communicator pure_nccl
