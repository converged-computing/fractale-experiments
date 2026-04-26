#! /bin/bash
#FLUX: --cwd=/s/ls4/users/leokul01/dineof3/script
#FLUX: --ntasks=1
#FLUX: --cores-per-task=48
#FLUX: --output=${FLUX_JOB_ID}.out
#FLUX: --error=${FLUX_JOB_ID}.err
#FLUX: --time-limit=2d23h59m59s
#FLUX: --queue=hpc4-3d

module load openmpi intel-compilers
export OPENBLAS_NUM_THREADS=2


### es - 3n - no thresh
# The original script used an undefined '$MPIRUN' variable.
# The standard way to launch a task under Flux is 'flux run'.
flux run -n 1 python main3_mp.py -c config/main3_default_ki_cluster.yml \
    --satellite-descriptor '../test/satellite_descriptor_ki_cluster_w3nt2.csv' \
    -S aqua \
    --logs ../test/reconstruction_logs/hooi_es_3neighbours_thresh2_aqua \
    --interpolated-stem interpolated_3neighbours_thresh2 \
    --output-stem Output_3neighbours_thresh2 \
    --decomposition-method hooi \
    --early-stopping 1
