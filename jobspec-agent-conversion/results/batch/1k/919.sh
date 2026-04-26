#!/bin/bash
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=1
#FLUX: --time-limit=2d
#FLUX: --job-name=ibs
#FLUX: --output=ibs_%j.out


PROJECT_FOLDER="ibs-dev"

#model=psycho
#model=vstm
model=fourinarow

# NOTE: This script is a job array. The SLURM_ARRAY_TASK_ID variable has been
# replaced with FLUX_JOB_CC. You must submit this job with 'flux submit --cc=1-120 ...'
proc_id=${FLUX_JOB_CC}

#method=ibs
method=fixed
#method=fixed
#method=fixedb
#method=exact
Nsamples=100

if [ $method = "exact" ]; then
    workdir=$SCRATCH/${PROJECT_FOLDER}/results/${model}/${method}
else
    workdir=$SCRATCH/${PROJECT_FOLDER}/results/${model}/${method}${Nsamples}
fi

module purge
module load matlab/2018a

mkdir $SCRATCH/${PROJECT_FOLDER}/results
mkdir $SCRATCH/${PROJECT_FOLDER}/results/${model}
mkdir $workdir
cd $workdir

echo $model $method $Nsamples $proc_id

echo "addpath('$SCRATCH/${PROJECT_FOLDER}/matlab/'); recover_theta('${model}','${method}',${proc_id},${Nsamples}); exit;" | matlab -nodisplay

echo "Done"
