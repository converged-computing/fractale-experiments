#!/bin/bash
#FLUX: --ntasks=20
#FLUX: --time-limit=5d


# instead of using the "SBATCH -o run_init-X.log" line here,
# include the flag "-o run_init-%A_%a.log" in the sbatch submission command:
# sbatch -o logs/run_gen_contamination_models-%A-%a.log --array=1-40 run_gen_contamination_models.sh

module load MATLAB/2019a
module load GCCcore/10.3.0
module load GCCcore/11.2.0
module load Gurobi/9.5.0

#use the upper line the first time it is run. If it generates some models and then for example runs out of time, the second line can be used to continue on the previous run
#matlab -nodesktop -nodisplay -nojvm -r "generate_DepMap_models('test'); exit" < /dev/null &

# The original script used ${SLURM_ARRAY_TASK_ID}, which implies it was submitted as a job array.
# The Flux equivalent is ${FLUX_JOB_CC}, but the --array directive was missing from the script itself.
# This script will only run as a single job unless submitted with the --cc flag.
matlab -nodesktop -nodisplay -nojvm -r "generate_contamination_models(${FLUX_JOB_CC}); exit" < /dev/null &

wait
