#!/bin/bash
#FLUX: --job-name="Elva paper winter experiments videos"
#FLUX: --time-limit=20h
#FLUX: --ntasks=1
#FLUX: --cores-per-task=1



DATASETS=(
        '2022-02-02-10-39-23_e2e_rec_elva_winter_lidar_forward_08' \
        '2022-02-02-10-50-07_e2e_rec_elva_winter_lidar_forward_08' \
        '2022-02-02-10-53-16_e2e_rec_elva_winter_lidar_backw_08' \
        '2022-02-02-11-05-18_e2e_rec_elva_winter_lidar-v5_forw_08' \
        '2022-02-02-11-18-14_e2e_rec_elva_winter_lidar-v5_backw_08' \
        '2022-02-02-11-32-37_e2e_rec_elva_winter_lidar-v3_forw_08' \
        '2022-02-02-11-45-34_e2e_rec_elva_winter_lidar-v3_backw_08' \
        '2022-02-02-11-58-48_e2e_rec_elva_winter_camera-v3_forw_08'
    )

module load any/python/3.8.3-conda
source activate ros2
cd /gpfs/space/home/rometaid/nvidia-e2e/viz

# NOTE: This script is a job array. The SLURM_ARRAY_TASK_ID variable has been
# replaced with FLUX_JOB_CC. You must submit this job with 'flux submit --cc=0-7 ...'
# srun is not required for a single task job in Flux
./create_driving_video.sh ${DATASETS[$FLUX_JOB_CC]}
