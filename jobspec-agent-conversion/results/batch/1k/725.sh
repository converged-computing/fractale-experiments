#!/bin/bash
#FLUX: --job-name=perses-benchmark
#FLUX: --cc=1-24
#FLUX: --ntasks=1
#FLUX: --nodes=1
#FLUX: --gpus-per-task=1
#FLUX: --time-limit=24h

# The LSF memory request (-R rusage[mem=8]) has no direct analog in flux and has been omitted.
# The LSF machine list (-m) and job priority (-sp) have no direct analogs and were omitted.
# LSF's dynamic output/error filenames (%J_%I) are not supported in Flux directives.
# We redirect output in the script body using Flux environment variables instead.

# Replicating the LSF behavior of redirecting output for each job in the array
exec > out_${FLUX_JOB_ID}_${FLUX_JOB_CC}.stdout 2> out_${FLUX_JOB_ID}_${FLUX_JOB_CC}.stderr

source ~/.bashrc
OPENMM_CPU_THREADS=1

# LSF's LS_SUBCWD corresponds to FLUX_SUBMIT_DIR
echo "changing directory to ${FLUX_SUBMIT_DIR}"
cd $FLUX_SUBMIT_DIR
conda activate perses-dev

# Report node in use
hostname

# Report CUDA info
env | sort | grep 'CUDA'

# launching a benchmark pair (target, edge) per job (0-based thus substract 1)
# LSF's LSB_JOBINDEX is replaced by FLUX_JOB_CC
python run_benchmarks.py --target tyk2 --edge $(( $FLUX_JOB_CC - 1 ))
