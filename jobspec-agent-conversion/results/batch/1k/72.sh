#!/bin/bash
#
# Synthesize the RA for the PAC D5005 board.
# This is an example script, how the synthesis can be started on Noctua using a HPCC FPGA configuration file.
# Submit this script to sbatch in this folder!

# The original script only specified a partition (-p fpgasyn), which is ignored in this conversion.
# No other resource requests were made, so no Flux directives are added.

module load intelFPGA_pro/20.3.0
module load intel_pac/19.2.0_usm
module load intel
module load devel/CMake/3.15.3-GCCcore-8.3.0

# Flux starts the job in the submission directory, so we can use a relative path
# instead of the original SLURM_SUBMIT_DIR variable.
BENCHMARK_DIR=../

SYNTH_DIR=${PFS_SCRATCH}/synth/pac/RA

CONFIG_NAMES=("Intel_PAC_D5005_IVDEP" "Intel_PAC_D5005_b1024")

for r in "${CONFIG_NAMES[@]}"; do
    BUILD_DIR=${SYNTH_DIR}/20.3.0-19.2.0-${r}

    mkdir -p ${BUILD_DIR}
    cd ${BUILD_DIR}

    cmake ${BENCHMARK_DIR} -Drt_PATH=/usr/lib64/librt.so -DHPCC_FPGA_CONFIG=${BENCHMARK_DIR}/configs/${r}.cmake

    make random_access_kernels_single_intel
done
