#!/bin/bash
#FLUX: --job-name=comp_422_openmp
#FLUX: --nodes=2
#FLUX: --tasks-per-node=1
#FLUX: --cores-per-task=14
#FLUX: --time-limit=10m

# The --mem slurm parameter has no direct analog in flux submit.
# This may affect job scheduling and performance if the job is memory-intensive.

ulimit -c unlimited -s
#module load impi/2019.2.187
#source /uufs/chpc.utah.edu/common/home/u1074259/ytopt/experiments/exp-6/jobs/000_00030.job                 
#python /uufs/chpc.utah.edu/common/home/u1074259/ytopt/problems/atax/executable.py --p0 a --p1 a --p2 c

# The total number of tasks is 2 (2 nodes * 1 task/node)
flux mini run -n 2 python -m ytopt.search.async_search --prob_path=problems/atax/problem.py --exp_dir=experiments/exp-2 --prob_attr=problem --exp_id=exp-2  --max_time=60 --base_estimator='RF'
#mpirun -np 2 python -m ytopt.search.async_search --prob_path=problems/correlation/problem.py --exp_dir=experiments/exp-6 --prob_attr=problem --exp_id=exp-6  --max_time=60 --base_estimator='RF'
