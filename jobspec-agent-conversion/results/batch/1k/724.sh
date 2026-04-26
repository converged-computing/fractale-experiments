#!/bin/bash
#FLUX: --job-name="tyk2-"
#FLUX: --cc=1-12
#FLUX: --ntasks=1
#FLUX: --nodes=1
#FLUX: --gpus-per-task=1
#FLUX: --time-limit=24h
#FLUX: --output=stdout/out.stdout
#FLUX: --error=stderr/out.stderr
#FLUX: --cwd=.

source ~/.bashrc
OPENMM_CPU_THREADS=1

echo "changing directory to ${LS_SUBCWD}"
conda activate perses-espaloma-0.3.0-v3

# Report node in use
hostname

# Report CUDA info
env | sort | grep 'CUDA'

mkdir -p stdout stderr
script_path="/home/takabak/data/espfit-experiment/scripts/pl-benchmark"
# launching a benchmark pair (target, edge) per job (0-based thus substract 1)
python ${script_path}/run_benchmarks.py --target tyk2 --edge $(( $FLUX_JOB_CC - 1 ))
