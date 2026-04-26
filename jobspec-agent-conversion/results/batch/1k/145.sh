#!/bin/sh
#FLUX: --job-name=hddm-paper
#FLUX: --nodes=20
#FLUX: --tasks-per-node=8
#FLUX: --time-limit=10h

source hddm_venv2/bin/activate

cd HDDM-paper

echo "Launching controller"
ipcontroller --profile=mpi &
sleep 10

echo "Launching engines"
mpirun -np 160 -x PATH -x PYTHON_PATH -x VIRTUAL_ENV -wd ~/HDDM-paper ipengine --profile=mpi &
sleep 10

echo "Launching job"
python ~/HDDM-paper/run_estimation.py -r -a --profile mpi --parallel --all -st -sz -z
