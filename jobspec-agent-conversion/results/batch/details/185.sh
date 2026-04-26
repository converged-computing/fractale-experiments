#!/bin/bash
# The -q (queue) and -W group_list directives are ignored.
# The PBS select statement is translated to the following flux directives:
#FLUX: --nodes=2
#FLUX: --tasks-per-node=2
#FLUX: --time-limit=15m

GROUP=$(id -ng)
MYDIR=/lustre/${GROUP}/${USER}
export HOME=$MYDIR

. $MYDIR/env.sh

cd $MYDIR

# デバッグ出力： Chainer と CuPy のバージョンを表示
python -c "import chainer; print(chainer.__version__)"
python -c "import cupy; print(cupy.cuda.nccl.get_version())"

# The mpiexec command is replaced by `flux mini run`
flux mini run -x PYTHONUSERBASE \
        python ./train_mnist.py -g --communicator pure_nccl
