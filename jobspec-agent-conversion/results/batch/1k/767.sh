#!/bin/bash
#FLUX: --job-name="rfm_Osu_mbw_mr_1_0_job"
#FLUX: --ntasks=64
#FLUX: --tasks-per-node=32
#FLUX: --nodes=2
#FLUX: --output=rfm_Osu_mbw_mr_1_0_job.out
#FLUX: --error=rfm_Osu_mbw_mr_1_0_job.err
#FLUX: --time-limit=15m
#FLUX: --exclusive

module load gcc/9.3.0-5abm3xg
module load openmpi/4.0.3-qpsxmnc
export SLURM_MPI_TYPE=pmix_v2
export UCX_NET_DEVICES=mlx5_0:1
module load osu-micro-benchmarks/5.6.2-vx3wtzo
flux run osu_mbw_mr
